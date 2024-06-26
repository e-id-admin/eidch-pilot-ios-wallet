import BITNetworking
import BITSdJWT
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SubmitPresentationUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockPresentationMetadata = .Mock.sample()
    mockCredential = .Mock.sample
    mockJWT = JWT.Mock.sample
    mockRequestObjet = .Mock.sample
    spyJWTGenerator = PresentationJWTGeneratorProtocolSpy()
    spyRepository = PresentationRepositoryProtocolSpy()
    useCase = SubmitPresentationUseCase(
      jwtGenerator: spyJWTGenerator,
      repository: spyRepository,
      addActivityUseCase: addActivityToCredentialUseCase)
  }

  func testSubmitPresentation_Success() async throws {

    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataReturnValue = mockJWT

    try await useCase.execute(requestObject: mockRequestObjet, credential: mockCredential, presentationMetadata: mockPresentationMetadata)

    XCTAssertNoThrow(spyRepository.submitPresentation(from:presentationRequestBody:))
    XCTAssertTrue(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
    XCTAssertEqual(1, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)

    XCTAssertTrue(spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCalled)
    XCTAssertEqual(1, spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCallsCount)

    XCTAssertNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.error)
    XCTAssertNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.errorDescription)
    XCTAssertNotNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.vpToken)
    XCTAssertNotNil(spyRepository.submitPresentationFromPresentationRequestBodyReceivedArguments?.presentationRequestBody.presentationSubmission)

    XCTAssertTrue(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .presentationAccepted)
    XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier?.name, mockPresentationMetadata.verifier?.clientName)
  }

  func testSubmitPresentation_Failure() async throws {
    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataThrowableError = TestingError.error

    do {
      try await useCase.execute(requestObject: mockRequestObjet, credential: mockCredential, presentationMetadata: mockPresentationMetadata)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCalled)
      XCTAssertEqual(1, spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataCallsCount)

      XCTAssertFalse(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(0, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)

      XCTAssertFalse(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testSubmitPresentation_VerificationFailed() async throws {
    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataReturnValue = mockJWT
    spyRepository.submitPresentationFromPresentationRequestBodyThrowableError = NetworkError(status: .internalServerError)

    do {
      try await useCase.execute(requestObject: mockRequestObjet, credential: mockCredential, presentationMetadata: mockPresentationMetadata)
      XCTFail("Should have thrown an exception")
    } catch is SubmitPresentationError {
      XCTAssertTrue(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(1, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)
      XCTAssertFalse(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
    } catch {
      XCTFail("Not the expected execution")
    }
  }

  func testSubmitPresentation_VerificationFailed_invalidCredential() async throws {
    spyJWTGenerator.generateRequestObjectRawCredentialPresentationMetadataReturnValue = mockJWT
    spyRepository.submitPresentationFromPresentationRequestBodyThrowableError = NetworkError(status: .invalidGrant)

    do {
      try await useCase.execute(requestObject: mockRequestObjet, credential: mockCredential, presentationMetadata: mockPresentationMetadata)
      XCTFail("Should have thrown an exception")
    } catch is SubmitPresentationError {
      XCTAssertTrue(spyRepository.submitPresentationFromPresentationRequestBodyCalled)
      XCTAssertEqual(1, spyRepository.submitPresentationFromPresentationRequestBodyCallsCount)
      XCTAssertTrue(addActivityToCredentialUseCase.executeTypeCredentialVerifierCalled)
      XCTAssertEqual(addActivityToCredentialUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .presentationAccepted)
    } catch {
      XCTFail("Not the expected execution")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var mockPresentationMetadata: PresentationMetadata!
  private var mockCredential: Credential!
  private var mockJWT: JWT!
  private var mockRequestObjet: RequestObject!
  private var useCase = SubmitPresentationUseCase()
  private var spyRepository = PresentationRepositoryProtocolSpy()
  private var spyJWTGenerator = PresentationJWTGeneratorProtocolSpy()
  private var addActivityToCredentialUseCase = AddActivityToCredentialUseCaseProtocolSpy()
  // swiftlint:enable all

}
