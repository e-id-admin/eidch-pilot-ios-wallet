import Factory
import Foundation

struct FetchMetadataUseCase: FetchMetadataUseCaseProtocol {

  init(repository: CredentialRepositoryProtocol = Container.shared.apiCredentialRepository()) {
    self.repository = repository
  }

  private let repository: CredentialRepositoryProtocol

  func execute(from issuerUrl: URL) async throws -> CredentialMetadata {
    try await repository.fetchMetadata(from: issuerUrl)
  }
}
