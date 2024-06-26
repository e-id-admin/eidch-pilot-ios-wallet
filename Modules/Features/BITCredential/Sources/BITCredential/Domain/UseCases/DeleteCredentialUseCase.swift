import BITCredentialShared
import BITVault
import Factory
import Foundation

// MARK: - DeleteCredentialError

enum DeleteCredentialError: Error {
  case invalidAlgorithm
}

// MARK: - DeleteCredentialUseCase

public struct DeleteCredentialUseCase: DeleteCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(
    databaseRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository(),
    keyManager: KeyManagerProtocol = Container.shared.keyManager(),
    hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol = Container.shared.hasDeletedCredentialRepository())
  {
    self.databaseRepository = databaseRepository
    self.keyManager = keyManager
    self.hasDeletedCredentialRepository = hasDeletedCredentialRepository
  }

  // MARK: Public

  public func execute(_ credential: Credential) async throws {
    var privateKeyError: Error?

    for rawCredential in credential.rawCredentials {
      guard let algorithm = VaultAlgorithm(rawValue: rawCredential.algorithm) else {
        privateKeyError = DeleteCredentialError.invalidAlgorithm
        continue
      }

      do {
        try keyManager.deleteKeyPair(
          withIdentifier: rawCredential.privateKeyIdentifier.uuidString,
          algorithm: algorithm)
      } catch {
        privateKeyError = error
      }
    }

    try await databaseRepository.delete(credential.id)
    hasDeletedCredentialRepository.setHasDeletedCredential()

    if let privateKeyError {
      throw privateKeyError
    }
  }

  // MARK: Private

  private let databaseRepository: CredentialRepositoryProtocol
  private let keyManager: KeyManagerProtocol
  private var hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol

}
