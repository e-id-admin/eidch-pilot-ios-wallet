import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITLocalAuthentication
@testable import BITTestingCore
@testable import BITVault

final class CredentialPrivateKeyGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    keyManagerProtocolSpy = KeyManagerProtocolSpy()
    generator = CredentialPrivateKeyGenerator(keyManager: keyManagerProtocolSpy, vaultAccessControlFlags: mockControlAccessFlags, vaultProtection: mockProtection, context: context)
  }

  func testCreatePrivateKey() throws {
    let mockSecKey = SecKeyTestsHelper.createPrivateKey()
    let mockAlgorithm = "ES256"
    let identifier = UUID()
    let mockReason = "mockReason"
    keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReturnValue = mockSecKey
    context.localizedReason = mockReason

    let privateKey = try generator.generate(identifier: identifier, algorithm: mockAlgorithm)
    XCTAssertEqual(mockSecKey, privateKey)
    XCTAssertTrue(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryCalled)
    XCTAssertEqual(identifier.uuidString, keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.identifier)
    XCTAssertEqual(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.algorithm, try VaultAlgorithm(fromSignatureAlgorithm: mockAlgorithm))
    XCTAssertEqual((keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.query?[kSecUseAuthenticationContext as String] as? LAContextProtocolSpy)?.localizedReason, mockReason) // Compare reason cause cannot compare LAContextProtocol
    // swiftlint:disable force_cast
    XCTAssertEqual(keyManagerProtocolSpy.generateKeyPairWithIdentifierAlgorithmOptionsQueryReceivedArguments?.query?[kSecAttrAccessControl as String] as! SecAccessControl, SecKeyTestsHelper.createAccessControl(accessControlFlags: mockControlAccessFlags, protection: mockProtection))
    // swiftlint:enable force_cast
  }

  // MARK: Private

  private var keyManagerProtocolSpy = KeyManagerProtocolSpy()
  private var generator = CredentialPrivateKeyGenerator()
  private var context = LAContextProtocolSpy()
  private var mockProtection = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  private var mockControlAccessFlags: SecAccessControlCreateFlags = [.privateKeyUsage, .applicationPassword]
}
