import BITSdJWT
import Factory
import Foundation

struct RevocationValidator: StatusCheckValidatorProtocol {

  // MARK: Lifecycle

  init(
    repository: CredentialRepositoryProtocol = Container.shared.apiCredentialRepository(),
    decoder: SdJWTDecoderProtocol = Container.shared.sdJwtDecoder())
  {
    self.repository = repository
    self.decoder = decoder
  }

  // MARK: Internal

  func validate(_ sdJwt: SdJWT) async throws -> Bool {
    guard
      let revocationStatus = sdJwt.revocationStatus,
      let suspensionStatus = sdJwt.suspensionStatus
    else { return false }

    async let isRevocated = try? isStatusInvalid(revocationStatus)
    async let isSuspended = try? isStatusInvalid(suspensionStatus)

    let statuses = await [isRevocated, isSuspended].compactMap({ $0 })

    guard statuses.count == 2 else {
      if let isInvalid = statuses.first, isInvalid { return false }
      throw StatusCheckError.unprocessableStatus
    }
    return statuses.allSatisfy({ !$0 })
  }

  // MARK: Private

  private let repository: CredentialRepositoryProtocol
  private let decoder: SdJWTDecoderProtocol

  private func isStatusInvalid(_ status: SdJWTCredentialStatus) async throws -> Bool {
    guard
      let url = URL(string: status.id),
      let index = Int(status.statusListIndex)
    else {
      throw StatusCheckError.invalidCredentialStatus
    }

    let statusJWT = try await repository.fetchCredentialStatus(from: url)
    let status = try decoder.decodeStatus(from: statusJWT, at: index)

    return status != 0
  }
}
