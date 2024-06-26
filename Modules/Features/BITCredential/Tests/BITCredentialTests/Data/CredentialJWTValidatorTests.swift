import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore
@testable import BITVault

// MARK: - CredentialJWTValidatorTests

final class CredentialJWTValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTManager = JWTManageableSpy()
    validator = CredentialJWTValidator(jwtManager: spyJWTManager, dateBuffer: 0.0)
  }

  func testValidateRawCredential() async throws {
    let mockFetchCredentialResponse: FetchCredentialResponse = .Mock.sample
    let mockIssuerPublicKeyInfo: IssuerPublicKeyInfo = .Mock.sample
    guard let mockCredentialsSupported: CredentialMetadata.CredentialsSupported = CredentialMetadata.Mock.sample.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value else {
      fatalError("Mock of CredentialMetadata doesn't contain valid credentialsSupported")
    }
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()

    spyJWTManager.createSecKeyFromECKeyCurveXYReturnValue = mockSecKey
    spyJWTManager.hasValidSignatureJwtPublicKeyReturnValue = true

    _ = try await validator.validate(mockFetchCredentialResponse, withPublicKeyInfo: mockIssuerPublicKeyInfo, selectedCredential: mockCredentialsSupported)

    XCTAssertTrue(spyJWTManager.createSecKeyFromECKeyCurveXYCalled)
    XCTAssertTrue(spyJWTManager.hasValidSignatureJwtPublicKeyCalled)
    XCTAssertEqual(mockFetchCredentialResponse.rawJWT?.asRawJWT(), spyJWTManager.hasValidSignatureJwtPublicKeyReceivedArguments?.jwt.raw)
    XCTAssertEqual(mockSecKey, spyJWTManager.hasValidSignatureJwtPublicKeyReceivedArguments?.publicKey)
  }

  func testJwtSignatureInvalid() async {
    guard let mockCredentialsSupported: CredentialMetadata.CredentialsSupported = CredentialMetadata.Mock.sample.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value else {
      fatalError("Mock of CredentialMetadata doesn't contain valid credentialsSupported")
    }
    spyJWTManager.createSecKeyFromECKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyJWTManager.hasValidSignatureJwtPublicKeyReturnValue = false

    do {
      _ = try await validator.validate(.Mock.sample, withPublicKeyInfo: .Mock.sample, selectedCredential: mockCredentialsSupported)
      XCTFail("An error was expected")
    } catch CredentialJWTValidatorError.invalidSignature {
      XCTAssertTrue(spyJWTManager.createSecKeyFromECKeyCurveXYCalled)
      XCTAssertTrue(spyJWTManager.hasValidSignatureJwtPublicKeyCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testSdJwtInvalid() async {
    guard let mockCredentialsSupported: CredentialMetadata.CredentialsSupported = CredentialMetadata.Mock.sample.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value else {
      fatalError("Mock of CredentialMetadata doesn't contain valid credentialsSupported")
    }
    spyJWTManager.createSecKeyFromECKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyJWTManager.hasValidSignatureJwtPublicKeyReturnValue = true

    do {
      _ = try await validator.validate(.Mock.sampleWithInvalidDisclosures, withPublicKeyInfo: .Mock.sample, selectedCredential: mockCredentialsSupported)
      XCTFail("An error was expected")
    } catch CredentialJWTValidatorError.invalidSdJWT {
      XCTAssertTrue(spyJWTManager.createSecKeyFromECKeyCurveXYCalled)
      XCTAssertTrue(spyJWTManager.hasValidSignatureJwtPublicKeyCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testJwtInvalid() async {
    guard let mockCredentialsSupported: CredentialMetadata.CredentialsSupported = CredentialMetadata.Mock.sample.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value else {
      fatalError("Mock of CredentialMetadata doesn't contain valid credentialsSupported")
    }
    spyJWTManager.createSecKeyFromECKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyJWTManager.hasValidSignatureJwtPublicKeyReturnValue = true

    do {
      _ = try await validator.validate(.Mock.sampleExpired, withPublicKeyInfo: .Mock.sample, selectedCredential: mockCredentialsSupported)
      XCTFail("An error was expected")
    } catch CredentialJWTValidatorError.invalidJWT {
      XCTAssertTrue(spyJWTManager.createSecKeyFromECKeyCurveXYCalled)
      XCTAssertTrue(spyJWTManager.hasValidSignatureJwtPublicKeyCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  func testMandatoryClaimMissing() async {
    guard let mockCredentialsSupported: CredentialMetadata.CredentialsSupported = CredentialMetadata.Mock.sample.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value else {
      fatalError("Mock of CredentialMetadata doesn't contain valid credentialsSupported")
    }
    let sdJwtMissingClaims: SdJWT = .Mock.sampleNoName
    let mockResponseMissingClaims: FetchCredentialResponse = .init(rawCredential: sdJwtMissingClaims.raw, format: "jwt_vc")
    spyJWTManager.createSecKeyFromECKeyCurveXYReturnValue = SecKeyTestsHelper.createPrivateKey()
    spyJWTManager.hasValidSignatureJwtPublicKeyReturnValue = true

    do {
      _ = try await validator.validate(mockResponseMissingClaims, withPublicKeyInfo: .Mock.sample, selectedCredential: mockCredentialsSupported)
      XCTFail("An error was expected")
    } catch CredentialJWTValidatorError.credentialMismatch {
      XCTAssertTrue(spyJWTManager.createSecKeyFromECKeyCurveXYCalled)
      XCTAssertTrue(spyJWTManager.hasValidSignatureJwtPublicKeyCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  // MARK: Private

  private var spyJWTManager = JWTManageableSpy()
  private var validator = CredentialJWTValidator()

}

extension String {
  fileprivate func asRawJWT() -> String? {
    let jwt = separatedByDisclosures.first.map(String.init) ?? self
    guard jwt.split(separator: ".").count == 3 else { return nil }
    return jwt
  }
}
