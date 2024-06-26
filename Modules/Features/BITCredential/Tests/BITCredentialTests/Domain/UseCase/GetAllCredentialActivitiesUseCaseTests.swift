import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class GetGroupedCredentialActivitiesUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    useCase = GetGroupedCredentialActivitiesUseCase(credentialActivityRepository: credentialActivityRepository)
  }

  func testGetActivities() async throws {
    credentialActivityRepository.getAllActivitiesForReturnValue = [.Mock.sampleReceive, .Mock.samplePresentation]

    let activities = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(activities.count, 2)
    XCTAssertTrue(credentialActivityRepository.getAllActivitiesForCalled)
    XCTAssertEqual(credentialActivityRepository.getAllActivitiesForReceivedCredential, mockCredential)
    XCTAssertEqual(activities[0].key, "JULY 2024")
    XCTAssertTrue(activities[0].value.contains(.Mock.samplePresentation))
    XCTAssertEqual(activities[1].key, "MARCH 2024")
    XCTAssertTrue(activities[1].value.contains(.Mock.sampleReceive))
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCredential: Credential = .Mock.sample
  private var useCase: GetGroupedCredentialActivitiesUseCase!
  private let credentialActivityRepository = CredentialActivityRepositoryProtocolSpy()
  // swiftlint:enable all
}
