import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITSdJWT
@testable import BITTestingCore
@testable import BITVault

final class CredentialDidJWKGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTManager = JWTManageableSpy()
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    generator = CredentialDidJWKGenerator(jwtManager: spyJWTManager, keyManager: keyManagerProtocolSpy)
  }

  func testCreateDidJwk() throws {
    let mockMetadataWrapper: CredentialMetadataWrapper = .Mock.sample
    let mockPrivateKey = SecKeyTestsHelper.createPrivateKey()
    let mockPublicKey = SecKeyTestsHelper.createPrivateKey()
    let mockJWK = "mock-jwk"
    keyManagerProtocolSpy.getPublicKeyForReturnValue = mockPublicKey
    spyJWTManager.createJWKFromReturnValue = mockJWK

    let didJwk = try generator.generate(from: mockMetadataWrapper, privateKey: mockPrivateKey)
    XCTAssertEqual("did:jwk:\(mockJWK)", didJwk)
    XCTAssertTrue(keyManagerProtocolSpy.getPublicKeyForCalled)
    XCTAssertEqual(mockPrivateKey, keyManagerProtocolSpy.getPublicKeyForReceivedPrivateKey)
    XCTAssertTrue(spyJWTManager.createJWKFromCalled)
    XCTAssertEqual(mockPublicKey, spyJWTManager.createJWKFromReceivedPublicKey)
  }

  // MARK: Private

  private var spyJWTManager = JWTManageableSpy()
  private var keyManagerProtocolSpy = KeyManagerProtocolSpy()
  private var generator = CredentialDidJWKGenerator()
}
