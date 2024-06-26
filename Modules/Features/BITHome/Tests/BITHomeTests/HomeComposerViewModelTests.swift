import Factory
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITHome
@testable import BITTestingCore

@MainActor
final class HomeComposerViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    getCredentialListUseCase = GetCredentialListUseCaseProtocolSpy()
    hasDeletedCredentialUseCase = HasDeletedCredentialUseCaseProtocolSpy()
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
    getLastActivityUseCase = GetLastActivityUseCaseProtocolSpy()

    viewModel = HomeViewModel(
      routes: HomeRouterMock(),
      getCredentialListUseCase: getCredentialListUseCase,
      hasDeletedCredentialUseCase: hasDeletedCredentialUseCase,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase,
      getLastActivityUseCase: getLastActivityUseCase)
  }

  func testInitialValues() {
    XCTAssertFalse(viewModel.isScannerPresented)
    XCTAssertFalse(viewModel.isActivitiesListPresented)
    XCTAssertFalse(viewModel.isActivityDetailPresented)
    XCTAssertFalse(viewModel.isMenuPresented)
    XCTAssertFalse(viewModel.isCredentialDetailPresented)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.lastActivityCredential)
  }

  func testLoadCredential_happyPath() async {
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    getLastActivityUseCase.executeReturnValue = .Mock.sampleReceive

    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, Credential.Mock.array)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertTrue(getLastActivityUseCase.executeCalled)
  }

  func testLoadCredential_emptyPath() async {
    getCredentialListUseCase.executeReturnValue = []
    getLastActivityUseCase.executeReturnValue = .Mock.sampleReceive
    hasDeletedCredentialUseCase.executeReturnValue = false
    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)

    XCTAssertTrue(hasDeletedCredentialUseCase.executeCalled)
    XCTAssertEqual(hasDeletedCredentialUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithoutDeletedCredential)

    XCTAssertFalse(getLastActivityUseCase.executeCalled)
  }

  func testRefresh() async {
    await testLoadCredential_emptyPath()
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    XCTAssertFalse(getCredentialListUseCase.executeReturnValue.isEmpty)
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testRefresh_fetchHappyPath_thenFailurePath() async {
    await testLoadCredential_happyPath()
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testRefresh_fetchEmpty_thenFailurePath() async {
    await testLoadCredential_emptyPath()
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .refresh)

    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 2)
    XCTAssertEqual(viewModel.state, .error)
    XCTAssertNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.lastActivityCredential)
  }

  func testLoadCredential_failurePath() async {
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .fetchCredentials)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .error)
    XCTAssertFalse(getLastActivityUseCase.executeCalled)
    XCTAssertNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.lastActivityCredential)
  }

  func testGetHasDeletedCredentialWithDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    hasDeletedCredentialUseCase.executeReturnValue = true
    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithDeletedCredential)
  }

  func testGetHasDeletedCredentialWithNoDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    hasDeletedCredentialUseCase.executeReturnValue = false
    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithoutDeletedCredential)
  }

  func testCheckAllCredentialsStatus_Success() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeReturnValue = mockCrendentials
    getLastActivityUseCase.executeReturnValue = .Mock.sampleReceive

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeReturnValue.count, mockCrendentials.count)
  }

  func testCheckAllCredentialsStatus_failure() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeThrowableError = TestingError.error
    getLastActivityUseCase.executeReturnValue = .Mock.sampleReceive

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
  }

  func testPresentCredentialDetails() {
    viewModel.showCredentialDetails()

    XCTAssertTrue(viewModel.isCredentialDetailPresented)
  }

  func testGetLastActivity_success() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    getLastActivityUseCase.executeReturnValue = .Mock.sampleReceive

    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertFalse(viewModel.credentials.isEmpty)
    XCTAssertNotNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNotNil(viewModel.lastActivity)
    XCTAssertNotNil(viewModel.lastActivityCredential)
  }

  func testGetLastActivity_failure() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    getLastActivityUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertFalse(viewModel.credentials.isEmpty)
    XCTAssertNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.lastActivityCredential)
    XCTAssertNotNil(viewModel.stateError)
  }

  func testGetLastActivity_notFound() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    getLastActivityUseCase.executeReturnValue = nil

    await viewModel.send(event: .fetchCredentials)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertFalse(viewModel.credentials.isEmpty)
    XCTAssertNil(viewModel.lastActivity)
    XCTAssertNil(viewModel.lastActivityCredential)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testShowActivitiesList() {
    viewModel.showActivitiesList()
    XCTAssertTrue(viewModel.isActivitiesListPresented)
  }

  func testShowActivityDetailsWithPresentationActivity() {
    viewModel.lastActivity = mockPresentationActivity
    viewModel.showActivityDetails()

    XCTAssertTrue(viewModel.isActivityDetailPresented)
  }

  func testShowActivityDetailsWithReceivedActivity() {
    viewModel.lastActivity = mockReceiveActivity
    viewModel.showActivityDetails()

    XCTAssertFalse(viewModel.isActivityDetailPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCrendentials = Credential.Mock.array
  private var getCredentialListUseCase: GetCredentialListUseCaseProtocolSpy!
  private var hasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocolSpy!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var getLastActivityUseCase: GetLastActivityUseCaseProtocolSpy!
  private var viewModel: HomeViewModel!
  private var mockPresentationActivity: Activity = .Mock.samplePresentation
  private var mockReceiveActivity: Activity = .Mock.sampleReceive
  // swiftlint:enable all

}
