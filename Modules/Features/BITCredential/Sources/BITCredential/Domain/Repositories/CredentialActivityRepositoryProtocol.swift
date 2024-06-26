import BITActivity
import BITCredentialShared
import Spyable

@Spyable
protocol CredentialActivityRepositoryProtocol {
  @discardableResult
  func addActivity(_ activity: Activity, to credential: Credential) async throws -> Activity
  func getAllActivities(for credential: Credential) async throws -> [Activity]
  func getLastActivities(for credential: Credential, count: Int) async throws -> [Activity]
}
