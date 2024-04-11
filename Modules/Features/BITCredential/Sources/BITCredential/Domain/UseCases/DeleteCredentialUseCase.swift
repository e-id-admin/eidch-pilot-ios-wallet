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
    vault: VaultProtocol = Container.shared.vault(),
    hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol = Container.shared.hasDeletedCredentialRepository())
  {
    self.databaseRepository = databaseRepository
    self.vault = vault
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
        try vault.deletePrivateKey(
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
  private let vault: VaultProtocol
  private var hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol

}
