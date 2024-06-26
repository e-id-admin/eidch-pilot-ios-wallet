import BITActivity
import BITCredentialShared
import Foundation
import Spyable

@Spyable
public protocol GetLastCredentialActivitiesUseCaseProtocol {
  func execute(for credential: Credential, count: Int) async throws -> [Activity]
}
