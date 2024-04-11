import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITTestingCore
@testable import BITVault

final class CredentialPrivateKeyGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyVault = VaultProtocolSpy()
    generator = CredentialPrivateKeyGenerator(vault: spyVault)
  }

  func testCreatePrivateKey() throws {
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()
    let mockAlgorithm = "ES256"
    let identifier = UUID()
    spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReturnValue = mockSecKey

    let privateKey = try generator.generate(identifier: identifier, algorithm: mockAlgorithm)
    XCTAssertEqual(mockSecKey, privateKey)
    XCTAssertTrue(spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonCalled)
    XCTAssertEqual(identifier.uuidString, spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.identifier)
  }

  // MARK: Private

  private var spyVault = VaultProtocolSpy()
  private var generator = CredentialPrivateKeyGenerator()
}
