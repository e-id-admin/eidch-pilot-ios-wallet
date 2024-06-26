import BITNetworking
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITTestingCore

final class DenyPresentationUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockRequestObject = .Mock.sample
    mockCredential = .Mock.sample
    mockPresentationMetadata = .Mock.sample()
    repository = PresentationRepositoryProtocolSpy()
    addActivityToCredentialUseCase = AddActivityToCredentialUseCaseProtocolSpy()
    useCase = DenyPresentationUseCase(repository: repository, addActivityUseCase: addActivityToCredentialUseCase)
  }

  func test_denyPresentationSuccess() async throws {
    try await useCase.execute(for: mockCredential, requestObject: mockRequestObject, and: mockPresentationMetadata)
    XCTAssertTrue(repository.submitPresentationFromPresentationRequestBodyCalled)
    XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyCallsCount, 1)
    XCTAssertTrue(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .presentationDeclined)
    XCTAssertNotNil(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier)
    validateRequestBody()
  }

  func test_denyPresentationFailure() async throws {
    repository.submitPresentationFromPresentationRequestBodyThrowableError = TestingError.error

    do {
      try await useCase.execute(for: mockCredential, requestObject: mockRequestObject, and: mockPresentationMetadata)
    } catch TestingError.error {
      XCTAssertTrue(repository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyCallsCount, 1)
      XCTAssertFalse(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
      validateRequestBody()
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  //swiftlint:disable all
  private var useCase: DenyPresentationUseCase!
  private var mockCredential: Credential!
  private var repository: PresentationRepositoryProtocolSpy!
  private var mockRequestObject: RequestObject!
  private var mockPresentationMetadata: PresentationMetadata!
  private var addActivityToCredentialUseCase: AddActivityToCredentialUseCaseProtocolSpy!

  //swiftlint:enable all

  private func validateRequestBody() {
    XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.error, .clientRejected)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.vpToken)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.presentationSubmission)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.errorDescription)
  }

}
