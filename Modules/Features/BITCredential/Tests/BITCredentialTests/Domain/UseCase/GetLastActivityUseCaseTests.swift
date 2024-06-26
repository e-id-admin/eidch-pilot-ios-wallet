import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITTestingCore

final class GetLastActivityUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    useCase = GetLastActivityUseCase(activityRepository: activityRepository)
  }

  func testGetLastActivity_success() async throws {
    activityRepository.getLastReturnValue = mockActivity

    let activity = try await useCase.execute()

    XCTAssertEqual(activity, activityRepository.getLastReturnValue)
    XCTAssertTrue(activityRepository.getLastCalled)
  }

  func testGetLastActivityRetursNil() async throws {
    activityRepository.getLastReturnValue = nil

    let activity = try await useCase.execute()

    XCTAssertNil(activity)
    XCTAssertTrue(activityRepository.getLastCalled)
  }

  func testGetLastActivity_failure() async throws {
    activityRepository.getLastThrowableError = TestingError.error

    do {
      _ = try await useCase.execute()
      XCTFail("Should fail instead...")
    } catch TestingError.error {
      XCTAssertTrue(activityRepository.getLastCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: GetLastActivityUseCase!
  private let activityRepository = ActivityRepositoryProtocolSpy()
  private let mockActivity: Activity = .Mock.samplePresentation
  // swiftlint:enable all
}
