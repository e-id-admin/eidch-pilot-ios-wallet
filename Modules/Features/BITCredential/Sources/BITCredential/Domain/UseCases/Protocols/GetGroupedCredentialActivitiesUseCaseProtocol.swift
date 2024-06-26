import BITActivity
import BITCredentialShared
import Spyable

@Spyable
public protocol GetGroupedCredentialActivitiesUseCaseProtocol {
  func execute(for credential: Credential) async throws -> [(key: String, value: [Activity])]
}
