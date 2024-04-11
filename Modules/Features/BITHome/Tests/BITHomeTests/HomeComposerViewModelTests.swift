import Factory
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITHome
@testable import BITTestingCore

@MainActor
final class HomeComposerViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    getCredentialListUseCase = GetCredentialListUseCaseProtocolSpy()
    hasDeletedCredentialUseCase = HasDeletedCredentialUseCaseProtocolSpy()
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()

    viewModel = HomeViewModel(
      routes: HomeRouterMock(),
      getCredentialListUseCase: getCredentialListUseCase,
      hasDeletedCredentialUseCase: hasDeletedCredentialUseCase,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase)
  }

  func testInitialValues() {
    XCTAssertFalse(viewModel.isScannerPresented)
    XCTAssertFalse(viewModel.isMenuPresented)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testLoadCredential_happyPath() async {
    getCredentialListUseCase.executeReturnValue = Credential.Mock.array
    await viewModel.send(event: .fetch)
    XCTAssertEqual(viewModel.credentials, Credential.Mock.array)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .results)
  }

  func testLoadCredential_emptyPath() async {
    getCredentialListUseCase.executeReturnValue = []
    hasDeletedCredentialUseCase.executeReturnValue = false
    await viewModel.send(event: .fetch)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)

    XCTAssertTrue(hasDeletedCredentialUseCase.executeCalled)
    XCTAssertEqual(hasDeletedCredentialUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithoutDeletedCredential)
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
  }

  func testLoadCredential_failurePath() async {
    getCredentialListUseCase.executeThrowableError = TestingError.error
    await viewModel.send(event: .fetch)
    XCTAssertEqual(viewModel.credentials, [])

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .error)
  }

  func testGetHasDeletedCredentialWithDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    hasDeletedCredentialUseCase.executeReturnValue = true
    await viewModel.send(event: .fetch)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithDeletedCredential)
  }

  func testGetHasDeletedCredentialWithNoDeletedCredential_Success() async {
    getCredentialListUseCase.executeReturnValue = []
    hasDeletedCredentialUseCase.executeReturnValue = false
    await viewModel.send(event: .fetch)

    XCTAssertTrue(getCredentialListUseCase.executeCalled)
    XCTAssertEqual(getCredentialListUseCase.executeCallsCount, 1)
    XCTAssertEqual(viewModel.state, .emptyWithoutDeletedCredential)
  }

  func testCheckAllCredentialsStatus_Success() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeReturnValue = mockCrendentials

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeReturnValue.count, mockCrendentials.count)
  }

  func testCheckAllCredentialsStatus_failure() async throws {
    getCredentialListUseCase.executeReturnValue = mockCrendentials
    checkAndUpdateCredentialStatusUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .checkCredentialsStatus)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCrendentials = Credential.Mock.array
  private var getCredentialListUseCase: GetCredentialListUseCaseProtocolSpy!
  private var hasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocolSpy!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var viewModel: HomeViewModel!
  // swiftlint:enable all

}
