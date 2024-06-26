import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks

final class DeleteActivityUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    activityRepository = ActivityRepositoryProtocolSpy()
    useCase = DeleteActivityUseCase(activityRepository: activityRepository)
  }

  func testDeleteActivity_success() async throws {
    let mockActivity: Activity = .Mock.sampleReceive

    try await useCase.execute(mockActivity)

    XCTAssertTrue(activityRepository.deleteCalled)
    XCTAssertEqual(activityRepository.deleteReceivedId, mockActivity.id)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase = DeleteActivityUseCase()
  private var activityRepository: ActivityRepositoryProtocolSpy!
  // swiftlint:enable all
}
