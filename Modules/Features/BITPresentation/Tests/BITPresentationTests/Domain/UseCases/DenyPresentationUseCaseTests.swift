import BITCredential
import BITNetworking
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITTestingCore

final class DenyPresentationUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockRequestObject = .Mock.sample
    repository = PresentationRepositoryProtocolSpy()
    useCase = DenyPresentationUseCase(repository: repository)
  }

  func test_denyPresentationSuccess() async throws {
    try await useCase.execute(requestObject: mockRequestObject)
    XCTAssertTrue(repository.submitPresentationFromPresentationRequestBodyCalled)
    XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyCallsCount, 1)
    validateRequestBody()
  }

  func test_denyPresentationFailure() async throws {
    repository.submitPresentationFromPresentationRequestBodyThrowableError = TestingError.error
    do {
      try await useCase.execute(requestObject: mockRequestObject)
    } catch TestingError.error {
      XCTAssertTrue(repository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyCallsCount, 1)
      validateRequestBody()
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  //swiftlint:disable all
  private var useCase: DenyPresentationUseCase!
  private var repository: PresentationRepositoryProtocolSpy!
  private var mockRequestObject: RequestObject!

  //swiftlint:enable all

  private func validateRequestBody() {
    XCTAssertEqual(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.error, .clientRejected)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.vpToken)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.presentationSubmission)
    XCTAssertNil(repository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.errorDescription)
  }

}
