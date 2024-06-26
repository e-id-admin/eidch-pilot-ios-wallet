import BITActivity
import BITCredentialShared
import Factory

struct GetLastCredentialActivitiesUseCase: GetLastCredentialActivitiesUseCaseProtocol {
  init(credentialActivityRepository: CredentialActivityRepositoryProtocol = Container.shared.credentialActivityRepository()) {
    self.credentialActivityRepository = credentialActivityRepository
  }

  func execute(for credential: Credential, count: Int) async throws -> [Activity] {
    try await credentialActivityRepository.getLastActivities(for: credential, count: count)
  }

  private let credentialActivityRepository: CredentialActivityRepositoryProtocol
}
