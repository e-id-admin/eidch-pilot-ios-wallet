import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITTestingCore

@MainActor
final class CredentialActivitiesViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    viewModel = CredentialActivitiesViewModel(
      .loading,
      credential: mockCredential,
      getGroupedCredentialActivitiesUseCase: getGroupedCredentialActivitiesUseCase,
      deleteActivityUseCase: deleteActivityUseCase)
  }

  func testInitialState() {
    XCTAssertTrue(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertNil(viewModel.stateError)
    XCTAssertFalse(viewModel.isActivityDetailPresented)
    XCTAssertNil(viewModel.selectedActivity)
  }

  func testFetchCredentialActivities_success() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = [
      ("JULI 2024", [.Mock.samplePresentation]),
      ("MARZ 2024", [.Mock.sampleReceive]),
    ]

    await viewModel.send(event: .fetchActivities)

    XCTAssertTrue(getGroupedCredentialActivitiesUseCase.executeForCalled)
    XCTAssertEqual(viewModel.groupedActivities.count, 2)
    XCTAssertEqual(getGroupedCredentialActivitiesUseCase.executeForReceivedCredential, mockCredential)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testFetchCredentialActivities_failure() async {
    getGroupedCredentialActivitiesUseCase.executeForThrowableError = TestingError.error

    await viewModel.send(event: .fetchActivities)

    XCTAssertTrue(getGroupedCredentialActivitiesUseCase.executeForCalled)
    XCTAssertTrue(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(getGroupedCredentialActivitiesUseCase.executeForReceivedCredential, mockCredential)
    XCTAssertNotNil(viewModel.stateError)
  }

  func testDeleteActivity_success() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = [
      ("JULI 2024", [mockActivity]),
    ]

    await viewModel.send(event: .fetchActivities)

    XCTAssertEqual(viewModel.groupedActivities.count, 1)

    await viewModel.send(event: .deleteActivity(mockActivity))

    XCTAssertTrue(deleteActivityUseCase.executeCalled)
    XCTAssertEqual(deleteActivityUseCase.executeReceivedActivity, mockActivity)
    XCTAssertTrue(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(viewModel.state, .empty)
  }

  func testDeleteActivity_failure() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = [
      ("JULI 2024", [mockActivity]),
    ]

    await viewModel.send(event: .fetchActivities)

    deleteActivityUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .deleteActivity(mockActivity))

    XCTAssertTrue(deleteActivityUseCase.executeCalled)
    XCTAssertEqual(deleteActivityUseCase.executeReceivedActivity, mockActivity)
    XCTAssertEqual(viewModel.groupedActivities.count, 1)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testEmptyState() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = [
      ("JULI 2024", [mockActivity]),
    ]

    await viewModel.send(event: .fetchActivities)
    await viewModel.send(event: .deleteActivity(mockActivity))

    XCTAssertTrue(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(viewModel.state, .empty)
  }

  func testFetchActivitiesWhenEmptyState() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = []

    viewModel = CredentialActivitiesViewModel(
      .empty,
      credential: mockCredential,
      getGroupedCredentialActivitiesUseCase: getGroupedCredentialActivitiesUseCase,
      deleteActivityUseCase: deleteActivityUseCase)

    await viewModel.send(event: .fetchActivities)

    XCTAssertTrue(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(viewModel.state, .empty)
    XCTAssertFalse(getGroupedCredentialActivitiesUseCase.executeForCalled)
    XCTAssertFalse(deleteActivityUseCase.executeCalled)
  }

  func testFetchActivitiesWhenResultsState() async {
    getGroupedCredentialActivitiesUseCase.executeForReturnValue = [
      ("JULI 2024", [.Mock.samplePresentation]),
      ("MARZ 2024", [.Mock.sampleReceive]),
    ]

    viewModel = CredentialActivitiesViewModel(
      .results,
      credential: mockCredential,
      getGroupedCredentialActivitiesUseCase: getGroupedCredentialActivitiesUseCase,
      deleteActivityUseCase: deleteActivityUseCase)

    await viewModel.send(event: .fetchActivities)

    XCTAssertFalse(viewModel.groupedActivities.isEmpty)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertTrue(getGroupedCredentialActivitiesUseCase.executeForCalled)
    XCTAssertFalse(deleteActivityUseCase.executeCalled)
  }

  func testShowActivityDetail() {
    viewModel.showActivityDetailView()
    XCTAssertTrue(viewModel.isActivityDetailPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockActivity: Activity = .Mock.sampleReceive
  private let mockCredential: Credential = .Mock.sample
  private var viewModel: CredentialActivitiesViewModel!
  private let getGroupedCredentialActivitiesUseCase = GetGroupedCredentialActivitiesUseCaseProtocolSpy()
  private let deleteActivityUseCase = DeleteActivityUseCaseProtocolSpy()
  // swiftlint:enable all
}
