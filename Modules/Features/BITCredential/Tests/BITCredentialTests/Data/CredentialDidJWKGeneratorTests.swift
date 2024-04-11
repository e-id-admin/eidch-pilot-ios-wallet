import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITSdJWT
@testable import BITTestingCore
@testable import BITVault

final class CredentialDidJWKGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyJWTManager = JWTManageableSpy()
    spyVault = VaultProtocolSpy()
    generator = CredentialDidJWKGenerator(jwtManager: spyJWTManager, vault: spyVault)
  }

  func testCreateDidJwk() throws {
    let mockMetadataWrapper: CredentialMetadataWrapper = .Mock.sample
    let mockPrivateKey = SecKeyTestsHelper.createPrivateKey()
    let mockPublicKey = SecKeyTestsHelper.createPrivateKey()
    let mockJWK = "mock-jwk"
    spyVault.getPublicKeyForReturnValue = mockPublicKey
    spyJWTManager.createJWKFromReturnValue = mockJWK

    let didJwk = try generator.generate(from: mockMetadataWrapper, privateKey: mockPrivateKey)
    XCTAssertEqual("did:jwk:\(mockJWK)", didJwk)
    XCTAssertTrue(spyVault.getPublicKeyForCalled)
    XCTAssertEqual(mockPrivateKey, spyVault.getPublicKeyForReceivedPrivateKey)
    XCTAssertTrue(spyJWTManager.createJWKFromCalled)
    XCTAssertEqual(mockPublicKey, spyJWTManager.createJWKFromReceivedPublicKey)
  }

  // MARK: Private

  private var spyJWTManager = JWTManageableSpy()
  private var spyVault = VaultProtocolSpy()
  private var generator = CredentialDidJWKGenerator()
}
