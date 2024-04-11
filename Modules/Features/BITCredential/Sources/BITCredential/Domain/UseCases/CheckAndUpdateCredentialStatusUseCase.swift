import BITSdJWT
import Factory
import Foundation

// MARK: - CheckCredentialStatusError

enum CheckCredentialStatusError: Error {
  case invalidCredential
}

// MARK: - CheckAndUpdateCredentialStatusUseCase

public struct CheckAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol {

  // MARK: Lifecycle

  init(
    localRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository(),
    dateBuffer: TimeInterval = Container.shared.dateBuffer(),
    validators: [any StatusCheckValidatorProtocol] = Container.shared.statusValidators())
  {
    self.localRepository = localRepository
    self.dateBuffer = dateBuffer
    self.validators = validators
  }

  // MARK: Public

  public func execute(_ credentials: [Credential]) async throws -> [Credential] {
    try await withThrowingTaskGroup(of: Credential.self, returning: [Credential].self) { taskGroup in

      for credential in credentials {
        taskGroup.addTask {
          let status = try await status(of: credential)
          return try await updateCredentialStatus(credential, to: status)
        }
      }

      return try await taskGroup.reduce(into: [Credential]()) { updatedCredentials, credential in
        updatedCredentials.append(credential)
      }
    }
  }

  public func execute(for credential: Credential) async throws -> Credential {
    let status = try await status(of: credential)
    return try await updateCredentialStatus(credential, to: status)
  }

  // MARK: Internal

  var validators: [any StatusCheckValidatorProtocol]

  // MARK: Private

  private let dateBuffer: TimeInterval
  private let localRepository: CredentialRepositoryProtocol

}

extension CheckAndUpdateCredentialStatusUseCase {

  private func status(of credential: Credential) async throws -> CredentialStatus {
    guard let sdJWTPayload = credential.rawCredentials.sdJWTPayload, let sdJwt = SdJWT(from: sdJWTPayload) else {
      throw CheckCredentialStatusError.invalidCredential
    }

    var isValid: Bool? = nil
    for index in 0..<validators.count where isValid != false {
      do {
        isValid = try await validators[index].validate(sdJwt)
      } catch {
        return credential.status
      }
    }

    guard let isValid else { return credential.status }
    return isValid ? .valid : .invalid
  }

  private func updateCredentialStatus(_ credential: Credential, to status: CredentialStatus) async throws -> Credential {
    var credentialCopy = credential
    credentialCopy.status = status

    return try await localRepository.update(credentialCopy)
  }
}
