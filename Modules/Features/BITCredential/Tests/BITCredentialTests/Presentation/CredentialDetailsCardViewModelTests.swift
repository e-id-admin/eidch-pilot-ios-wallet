import BITSdJWT
import Factory
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITTestingCore

@MainActor
final class CredentialDetailsCardViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
    deleteCredentialUseCase = DeleteCredentialUseCaseProtocolSpy()

    viewModel = CredentialDetailsCardViewModel(
      credential: mockCredential,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase,
      deleteCredentialUseCase: deleteCredentialUseCase)
  }

  func testInitialState() {
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
    XCTAssertNil(viewModel.credentialDetailBody)
    XCTAssertFalse(viewModel.isDeleteCredentialPresented)
  }

  func testLoadcredentialDetailBody_withStatusCheckSucceed_success() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = mockCredential

    await viewModel.send(event: .checkStatus)

    XCTAssertNotNil(viewModel.credentialDetailBody)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)

    XCTAssertFalse(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 0)
  }

  func testLoadcredentialDetailBody_withStatusCheckFailed_success() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForThrowableError = TestingError.error

    await viewModel.send(event: .checkStatus)

    XCTAssertNotNil(viewModel.credentialDetailBody)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)

    XCTAssertFalse(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 0)
  }

  // MARK: Private

  private let mockCredential: Credential = .Mock.sample

  // swiftlint:disable all
  private var viewModel: CredentialDetailsCardViewModel!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocolSpy!
  // swiftlint:enable all
}
