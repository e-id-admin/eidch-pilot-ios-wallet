import BITCredential
import BITNetworking
import BITSdJWT
import XCTest
@testable import BITCredentialMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SubmitPresentationUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockPresentationMetadata = .Mock.sample()
    mockRawCredential = .Mock.sample
    mockJWT = JWT.Mock.sample
    mockRequestObjet = .Mock.sample
    spyJWTGenerator = PresentationJWTGeneratorProtocolSpy()
    spyRepository = PresentationRepositoryProtocolSpy()
    useCase = SubmitPresentationUseCase(
      jwtGenerator: spyJWTGenerator,
      repository: spyRepository)
  }

  func testSubmitPresentation_Success() async throws {

    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataReturnValue = mockJWT

    try await useCase.execute(requestObject: mockRequestObjet, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)

    XCTAssertNoThrow(spyRepository.submitPresentation(from:presentationRequestBody:))
    XCTAssertTrue(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
    XCTAssertEqual(1, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)

    XCTAssertTrue(spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertEqual(1, spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCallsCount)

    XCTAssertNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.error)
    XCTAssertNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.errorDescription)
    XCTAssertNotNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.vpToken)
    XCTAssertNotNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.presentationSubmission)
  }

  func testSubmitPresentation_Failure() async throws {
    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataThrowableError = TestingError.error

    do {
      try await useCase.execute(requestObject: mockRequestObjet, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCalled)
      XCTAssertEqual(1, spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCallsCount)

      XCTAssertFalse(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(0, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testSubmitPresentation_VerificationFailed() async throws {
    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataReturnValue = mockJWT
    spyRepository.submitPresentationFromPresentationRequestBodyThrowableError = NetworkError.internalServerError

    do {
      try await useCase.execute(requestObject: mockRequestObjet, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)
      XCTFail("Should have thrown an exception")
    } catch is SubmitPresentationError {
      XCTAssertTrue(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(1, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)
    } catch {
      XCTFail("No the expected execution")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var mockPresentationMetadata: PresentationMetadata!
  private var mockRawCredential: RawCredential!
  private var mockJWT: JWT!
  private var mockRequestObjet: RequestObject!
  private var useCase = SubmitPresentationUseCase()
  private var spyRepository = PresentationRepositoryProtocolSpy()
  private var spyJWTGenerator = PresentationJWTGeneratorProtocolSpy()
  // swiftlint:enable all

}
