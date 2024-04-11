import Factory
import Foundation
import Spyable
import XCTest
@testable import BITCredential
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore
@testable import BITVault

final class CredentialJWTGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTManager = JWTManageableSpy()
    generator = CredentialJWTGenerator(jwtManager: spyJWTManager)
  }

  func testGenerate() throws {
    let mockCredentialIssuer = "mockCredentialIssuer"
    let mockDidJwk = "mockDidJwk"
    let mockAlgorithm = JWTAlgorithm.ES256.rawValue
    let mockPrivateKey = SecKeyTestsHelper.createPrivateKey()
    let mockNounce = "mockNounce"
    let mockJwt: JWT = .Mock.sample
    spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyReturnValue = mockJwt

    let jwt = try generator.generate(credentialIssuer: mockCredentialIssuer, didJwk: mockDidJwk, algorithm: mockAlgorithm, privateKey: mockPrivateKey, nounce: mockNounce)
    XCTAssertEqual(mockJwt, jwt)
    XCTAssertTrue(spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
    XCTAssertEqual(mockDidJwk, spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyReceivedArguments?.did)
    XCTAssertEqual(mockPrivateKey, spyJWTManager.createJWTPayloadDataAlgorithmDidPrivateKeyReceivedArguments?.privateKey)
  }

  func testGenerate_unknownAlgorithm() throws {
    let mockAlgorithm = "unknown"
    do {
      _ = try generator.generate(credentialIssuer: "mockCredentialIssuer", didJwk: "mockDidJwk", algorithm: mockAlgorithm, privateKey: SecKeyTestsHelper.createPrivateKey(), nounce: "mockNounce")
      XCTFail("An error is expected")
    } catch CredentialJWTGeneratorError.unsupportedAlgorithm {
      /* expected error */
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  private var spyJWTManager = JWTManageableSpy()
  private var generator = CredentialJWTGenerator()
}
