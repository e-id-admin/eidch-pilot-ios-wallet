import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class GetLastCredentialActivitiesUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    useCase = GetLastCredentialActivitiesUseCase(credentialActivityRepository: credentialActivityRepository)
  }

  func testGetLastActivities() async throws {
    let mockCount = 1
    credentialActivityRepository.getLastActivitiesForCountReturnValue = mockActivities

    let activities = try await useCase.execute(for: mockCredential, count: mockCount)

    XCTAssertEqual(activities.count, mockCount)
    XCTAssertTrue(credentialActivityRepository.getLastActivitiesForCountCalled)
    XCTAssertEqual(credentialActivityRepository.getLastActivitiesForCountReturnValue, mockActivities)
  }

  func testGetTooManyLastActivities() async throws {
    let mockCount = 10
    credentialActivityRepository.getLastActivitiesForCountReturnValue = mockActivities

    let activities = try await useCase.execute(for: mockCredential, count: mockCount)

    XCTAssertEqual(activities.count, mockActivities.count)
    XCTAssertTrue(credentialActivityRepository.getLastActivitiesForCountCalled)
    XCTAssertEqual(credentialActivityRepository.getLastActivitiesForCountReturnValue, mockActivities)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCredential: Credential = .Mock.sample
  private let mockActivities: [Activity] = [.Mock.sampleReceive]
  private var useCase: GetLastCredentialActivitiesUseCase!
  private let credentialActivityRepository = CredentialActivityRepositoryProtocolSpy()
  // swiftlint:enable all
}
