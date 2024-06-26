import BITActivity
import BITCredentialShared
import Factory
import Foundation

struct GetGroupedCredentialActivitiesUseCase: GetGroupedCredentialActivitiesUseCaseProtocol {

  init(credentialActivityRepository: CredentialActivityRepositoryProtocol = Container.shared.credentialActivityRepository()) {
    self.credentialActivityRepository = credentialActivityRepository
  }

  func execute(for credential: Credential) async throws -> [(key: String, value: [Activity])] {
    let activities = try await credentialActivityRepository.getAllActivities(for: credential)
    return Dictionary(grouping: activities, by: { DateFormatter.yearMonthGroupedFormatter.string(from: $0.createdAt).uppercased() })
      .sorted { $0.key < $1.key }
  }

  private let credentialActivityRepository: CredentialActivityRepositoryProtocol
}
