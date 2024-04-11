import BITCredential
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITTestingCore

@MainActor
class PresentationRequestMetadataViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    mockRequestObjectMock = .Mock.sample
    submitPresentationUseCase = SubmitPresentationUseCaseProtocolSpy()
    denyPresentationUseCase = DenyPresentationUseCaseProtocolSpy()

    viewModel = PresentationRequestMetadataViewModel(
      requestObject: mockRequestObjectMock,
      selectedCredential: selectedCredentialMock,
      submitPresentationUseCase: submitPresentationUseCase,
      denyPresentationUseCase: denyPresentationUseCase,
      completed: {
        self.completed = true
      })
  }

  func testInitialState() throws {
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertFalse(completed)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertNotNil(viewModel.presentationMetadata)
  }

  func testHappyPath() async throws {
    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(completed)
    XCTAssertTrue(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertTrue(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertEqual(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCallsCount, 1)
    XCTAssertFalse(denyPresentationUseCase.executeRequestObjectCalled)
  }

  func testFailurePath() async throws {
    submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataThrowableError = TestingError.error

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertEqual(viewModel.state, .error)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertEqual(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCallsCount, 1)
    XCTAssertFalse(denyPresentationUseCase.executeRequestObjectCalled)
    XCTAssertFalse(completed)
  }

  func testDeny() async throws {
    await viewModel.send(event: .deny)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(completed)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertTrue(viewModel.isRequestDeclineViewPresented)
    XCTAssertTrue(denyPresentationUseCase.executeRequestObjectCalled)
    XCTAssertEqual(denyPresentationUseCase.executeRequestObjectCallsCount, 1)
  }

  func testClose() async throws {
    await viewModel.send(event: .close)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertFalse(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertFalse(denyPresentationUseCase.executeRequestObjectCalled)
    XCTAssertTrue(completed)
  }

  func test_presentationSubmit_suspendedCredential() async throws {
    submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataThrowableError = SubmitPresentationError.credentialInvalid

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertEqual(viewModel.state, .invalidCredentialError)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertFalse(completed)
  }

  func test_presentationSubmit_revokedCredential() async throws {
    submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataThrowableError = SubmitPresentationError.credentialInvalid

    await viewModel.send(event: .submit)

    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isResultViewPresented)
    XCTAssertFalse(viewModel.isRequestDeclineViewPresented)
    XCTAssertEqual(viewModel.state, .invalidCredentialError)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(submitPresentationUseCase.executeRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertFalse(completed)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PresentationRequestMetadataViewModel!
  private var submitPresentationUseCase: SubmitPresentationUseCaseProtocolSpy!
  private var denyPresentationUseCase: DenyPresentationUseCaseProtocolSpy!
  private let selectedCredentialMock: CompatibleCredential = .Mock.BIT
  private var mockRequestObjectMock: RequestObject!
  private var completed: Bool = false
  // swiftlint:enable all
}
