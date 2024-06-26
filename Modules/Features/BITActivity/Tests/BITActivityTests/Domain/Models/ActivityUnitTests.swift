import BITDataStore
import Factory
import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class ActivityUnitTests: XCTestCase {

  func testActivityIsNilWhenInvalidType() async throws {
    let mockActivity = Activity(.Mock.sample, activityType: .credentialReceived, verifier: nil)
    let activityEntity = ActivityEntity(context: Container.shared.dataStore().managedContext, activity: mockActivity)
    activityEntity.type = "unknown_type"

    let activity: Activity? = Activity(activityEntity)

    XCTAssertNil(activity)
  }
}
