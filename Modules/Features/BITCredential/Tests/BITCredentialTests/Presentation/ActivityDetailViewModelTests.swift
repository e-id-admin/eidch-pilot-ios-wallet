import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITTestingCore

final class ActivityDetailViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    viewModel = ActivityDetailViewModel(
      mockActivity,
      deleteActityUseCase: deleteActivityUseCase)
  }

  func testInitialState() {
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertNotNil(viewModel.activity)
    XCTAssertNotNil(viewModel.verifierLogo)
    XCTAssertNotNil(viewModel.verifierName)
  }

  func testDeleteActivity_success() async {
    await viewModel.deleteActivity()

    XCTAssertTrue(deleteActivityUseCase.executeCalled)
    XCTAssertEqual(deleteActivityUseCase.executeReceivedActivity, mockActivity)
    XCTAssertTrue(viewModel.isPresented)
  }

  func testDeleteActivity_failure() async {
    deleteActivityUseCase.executeThrowableError = TestingError.error

    await viewModel.deleteActivity()

    XCTAssertTrue(deleteActivityUseCase.executeCalled)
    XCTAssertEqual(deleteActivityUseCase.executeReceivedActivity, mockActivity)
    XCTAssertTrue(viewModel.isPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockActivity: Activity = .Mock.samplePresentation
  private var viewModel: ActivityDetailViewModel!
  private let deleteActivityUseCase = DeleteActivityUseCaseProtocolSpy()
  // swiftlint:enable all
}
