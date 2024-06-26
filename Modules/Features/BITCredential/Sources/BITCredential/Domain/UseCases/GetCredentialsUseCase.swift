import BITCredentialShared
import Factory
import Foundation

// MARK: - GetCredentialsUseCase

public struct GetCredentialListUseCase: GetCredentialListUseCaseProtocol {

  let databaseRepository: CredentialRepositoryProtocol

  init(databaseRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository()) {
    self.databaseRepository = databaseRepository
  }

  public func execute() async throws -> [Credential] {
    try await databaseRepository.getAll()
  }

}
