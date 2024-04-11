import BITCredential
import Factory
import Spyable
import XCTest
@testable import BITCredentialMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore
@testable import BITVault

final class GenerateVpJWTUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyVault = VaultProtocolSpy()
    spyJWTManager = JWTManageableSpy()
    generator = PresentationJWTGenerator(vault: spyVault, jwtManager: spyJWTManager)
  }

  func testGenerateVpJWT_Success() async throws {
    let mockVpJWT: JWT = .Mock.sample
    spyJWTManager.createJWKFromReturnValue = "mock-jwk"
    spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyReturnValue = mockVpJWT

    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let publicKey = SecKeyTestsHelper.getPublicKey(for: privateKey)
    spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonReturnValue = privateKey
    spyVault.getPublicKeyForReturnValue = publicKey

    let vpJWT = try generator.generate(
      requestObject: .Mock.sample,
      rawCredential: .Mock.sample,
      presentationMetadata: .Mock.sample())

    XCTAssertEqual(mockVpJWT, vpJWT)

    XCTAssertTrue(spyJWTManager.createJWKFromCalled)
    XCTAssertEqual(1, spyJWTManager.createJWKFromCallsCount)
    XCTAssertEqual(spyJWTManager.createJWKFromReceivedPublicKey, publicKey)
    XCTAssertTrue(spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
    XCTAssertEqual(1, spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCallsCount)

    XCTAssertTrue(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
    XCTAssertEqual(1, spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCallsCount)
    XCTAssertTrue(spyVault.getPublicKeyForCalled)
    XCTAssertEqual(1, spyVault.getPublicKeyForCallsCount)
  }

  func testGenerateVpJWT_VaultFailure() async throws {
    spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonThrowableError = TestingError.error

    do {
      _ = try generator.generate(requestObject: .Mock.sample, rawCredential: .Mock.sample, presentationMetadata: .Mock.sample())
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
      XCTAssertEqual(1, spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCallsCount)
      XCTAssertFalse(spyVault.getPublicKeyForCalled)
      XCTAssertFalse(spyJWTManager.createJWKFromCalled)
      XCTAssertFalse(spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testGenerateVpJWT_JWTManagerFailure() async throws {
    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let publicKey = SecKeyTestsHelper.getPublicKey(for: privateKey)
    spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonReturnValue = privateKey
    spyVault.getPublicKeyForReturnValue = publicKey

    spyJWTManager.createJWKFromReturnValue = "mock-jwk"
    spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyThrowableError = TestingError.error

    do {
      _ = try generator.generate(requestObject: .Mock.sample, rawCredential: .Mock.sample, presentationMetadata: .Mock.sample())
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(spyJWTManager.createJWKFromCalled)
      XCTAssertEqual(1, spyJWTManager.createJWKFromCallsCount)
      XCTAssertTrue(spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
      XCTAssertEqual(1, spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCallsCount)
      XCTAssertTrue(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
      XCTAssertEqual(1, spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCallsCount)
      XCTAssertTrue(spyVault.getPublicKeyForCalled)
      XCTAssertEqual(1, spyVault.getPublicKeyForCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private var spyJWTManager = JWTManageableSpy()
  private var spyVault = VaultProtocolSpy()
  private var generator = PresentationJWTGenerator()

}
