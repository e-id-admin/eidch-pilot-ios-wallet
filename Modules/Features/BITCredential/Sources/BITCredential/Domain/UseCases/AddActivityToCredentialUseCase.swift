import BITActivity
import BITAnalytics
import BITCredentialShared
import Factory

struct AddActivityToCredentialUseCase: AddActivityToCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(
    credentialActivityRepository: CredentialActivityRepositoryProtocol = Container.shared.credentialActivityRepository(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.analytics = analytics
    self.credentialActivityRepository = credentialActivityRepository
  }

  // MARK: Internal

  enum AnalyticsEvent: AnalyticsEventProtocol {
    case cannotCreateActivity
  }

  func execute(type: ActivityType, credential: Credential, verifier: ActivityVerifier?) async throws {
    let activity = Activity(credential, activityType: type, verifier: verifier)

    do {
      try await credentialActivityRepository.addActivity(activity, to: credential)
    } catch {
      analytics.log(AnalyticsEvent.cannotCreateActivity)
    }
  }

  // MARK: Private

  private let analytics: AnalyticsProtocol
  private let credentialActivityRepository: CredentialActivityRepositoryProtocol
}
