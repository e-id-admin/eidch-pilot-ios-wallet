import BITNetworking
import BITSdJWT
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class FetchCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyRepository = CredentialRepositoryProtocolSpy()
    spyJWTGenerator = CredentialJWTGeneratorProtocolSpy()
    spyDidJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
    spyKeyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
    spyJWTValidator = CredentialJWTValidatorProtocolSpy()

    spyRepository.fetchOpenIdConfigurationFromReturnValue = .Mock.sample
    spyKeyPairGenerator.generateIdentifierAlgorithmReturnValue = mockSecKey
    spyDidJWKGenerator.generateFromPrivateKeyReturnValue = mockDidJwk
    spyRepository.fetchAccessTokenFromPreAuthorizedCodeReturnValue = mockAccessToken
    spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceReturnValue = mockJWT
    spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenReturnValue = mockResponse
    spyRepository.fetchIssuerPublicKeyInfoFromReturnValue = mockIssuerPublicKeyInfo
    spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialReturnValue = mockSdJwt

    useCase = FetchCredentialUseCase(
      credentialJWTGenerator: spyJWTGenerator,
      credentialDidJWKGenerator: spyDidJWKGenerator,
      credentialKeyPairGenerator: spyKeyPairGenerator,
      credentialJWTValidator: spyJWTValidator, repository: spyRepository)
  }

  func testFetchCredentialSuccess_withAccessToken() async throws {
    let credential = try await useCase.execute(
      from: mockUrl,
      metadataWrapper: mockMetadataWrapper,
      credentialOffer: mockCredentialOffer,
      accessToken: mockAccessToken)

    XCTAssertEqual(mockSdJwt, credential)
    XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
    XCTAssertTrue(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertTrue(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
    XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(spyDidJWKGenerator.generateFromPrivateKeyCalled)
    XCTAssertTrue(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
    XCTAssertTrue(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
  }

  func testFetchCredentialSuccess_withoutAccessToken() async throws {
    let credential = try await useCase.execute(
      from: mockUrl,
      metadataWrapper: mockMetadataWrapper,
      credentialOffer: mockCredentialOffer,
      accessToken: nil)

    XCTAssertEqual(mockSdJwt, credential)
    XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
    XCTAssertTrue(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    XCTAssertTrue(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
    XCTAssertTrue(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
    XCTAssertTrue(spyDidJWKGenerator.generateFromPrivateKeyCalled)
    XCTAssertTrue(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
    XCTAssertTrue(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
  }

  func testFetchCredentialFailure_unsupportedAlgorithm() async {
    let metadataWrapperUnknownAlgorithm = CredentialMetadataWrapper.Mock.sampleUnknownAlgorithm
    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: metadataWrapperUnknownAlgorithm,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.unsupportedAlgorithm {
      XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
      XCTAssertFalse(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testAccessTokenInvalidGrant() async {
    spyRepository.fetchAccessTokenFromPreAuthorizedCodeThrowableError = NetworkError(status: .invalidGrant)

    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapper,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.expiredInvitation {
      XCTAssertTrue(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertTrue(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertTrue(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertTrue(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
      XCTAssertFalse(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testCredentialEnpoindInvalid() async {
    let invalidEndpoint = ""
    let mockMetadataWrapperInvalid: CredentialMetadataWrapper = .init(selectedCredentialSupportedId: "123", credentialMetadata: .init(credentialIssuer: "valid-issuer", credentialEndpoint: invalidEndpoint, credentialsSupported: [:], display: []))
    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapperInvalid,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch FetchCredentialError.credentialEndpointCreationError {
      XCTAssertFalse(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
      XCTAssertFalse(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testNoFormatAvailable() async {
    let unknownId = "unknown-id"
    let mockMetadataWrapperInvalid: CredentialMetadataWrapper = .init(selectedCredentialSupportedId: unknownId, credentialMetadata: .init(credentialIssuer: "valid-issuer", credentialEndpoint: "some://valid-url", credentialsSupported: [:], display: []))
    do {
      _ = try await useCase.execute(
        from: mockUrl,
        metadataWrapper: mockMetadataWrapperInvalid,
        credentialOffer: mockCredentialOffer,
        accessToken: nil)
      XCTFail("An error was expected")
    } catch CredentialError.selectedCredentialNotFound {
      XCTAssertFalse(spyRepository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(spyRepository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
      XCTAssertFalse(spyRepository.fetchIssuerPublicKeyInfoFromCalled)
      XCTAssertFalse(spyRepository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(spyKeyPairGenerator.generateIdentifierAlgorithmCalled)
      XCTAssertFalse(spyDidJWKGenerator.generateFromPrivateKeyCalled)
      XCTAssertFalse(spyJWTGenerator.generateCredentialIssuerDidJwkAlgorithmPrivateKeyNounceCalled)
      XCTAssertFalse(spyJWTValidator.validateWithPublicKeyInfoSelectedCredentialCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  private let mockSecKey = SecKeyTestsHelper.createPrivateKey()
  private let mockDidJwk = "mockDidJwk"
  private let mockJWT: JWT = .Mock.sample
  private let mockResponse: FetchCredentialResponse = .Mock.sample
  private let mockIssuerPublicKeyInfo: IssuerPublicKeyInfo = .Mock.sample
  private let mockSdJwt: SdJWT = .Mock.sample
  private let mockMetadataWrapper: CredentialMetadataWrapper = .Mock.sample
  private let mockCredentialOffer: CredentialOffer = .Mock.sample
  private let mockAccessToken: AccessToken = .Mock.sample
  // swiftlint:disable all
  private let mockUrl: URL = .init(string: "some://url")!
  // swiftlint:enable all
  private var spyJWTGenerator = CredentialJWTGeneratorProtocolSpy()
  private var spyDidJWKGenerator = CredentialDidJWKGeneratorProtocolSpy()
  private var spyKeyPairGenerator = CredentialKeyPairGeneratorProtocolSpy()
  private var spyJWTValidator = CredentialJWTValidatorProtocolSpy()
  private var spyRepository = CredentialRepositoryProtocolSpy()
  private var useCase = FetchCredentialUseCase()

}
