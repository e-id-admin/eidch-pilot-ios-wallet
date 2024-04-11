import BITCore
import BITCrypto
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITTestingCore
@testable import BITVault

// MARK: - PepperRepositoryTests

final class PepperRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyContext = LAContextProtocolSpy()
    spyVault = VaultProtocolSpy()
    repository = SecretsRepository(vault: spyVault)
  }

  func testCreatePepperKey() throws {
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReturnValue = mockSecKey
    let secKey = try repository.createPepperKey()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(spyVault.deletePrivateKeyWithIdentifierAlgorithmCalled)
    XCTAssertEqual(vaultAlgorithm, spyVault.deletePrivateKeyWithIdentifierAlgorithmReceivedArguments?.algorithm)
    XCTAssertTrue(spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonCalled)
    XCTAssertEqual(vaultAlgorithm, spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.algorithm)
    XCTAssertEqual([.privateKeyUsage], spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.accessControlFlags)
    XCTAssertEqual(kSecAttrAccessibleWhenUnlockedThisDeviceOnly, spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.protection)
    XCTAssertEqual([.secureEnclavePermanently], spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.options)
    XCTAssertEqual(spyVault.deletePrivateKeyWithIdentifierAlgorithmReceivedArguments?.identifier, spyVault.generatePrivateKeyWithIdentifierAlgorithmAccessControlFlagsProtectionOptionsContextReasonReceivedArguments?.identifier)
  }

  func testGetPepperKey() throws {
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonReturnValue = mockSecKey
    let secKey = try repository.getPepperKey()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
    XCTAssertEqual(vaultAlgorithm, spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonReceivedArguments?.algorithm)
  }

  func testGetPeppeInitialVector() throws {
    let mockData: Data = .init()
    spyVault.getSecretForServiceContextReasonReturnValue = mockData
    let data = try repository.getPepperInitialVector()
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(spyVault.getSecretForServiceContextReasonCalled)
  }

  func testSetPepperInitialVector() throws {
    let mockData: Data = .init()
    try repository.setPepperInitialVector(mockData)
    XCTAssertTrue(spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonCalled)
    XCTAssertEqual(mockData, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.data)
    XCTAssertEqual(kSecAttrAccessibleWhenUnlockedThisDeviceOnly, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.protection)
    XCTAssertEqual(true, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.canOverride)
  }

  // MARK: Private

  private let vaultAlgorithm: VaultAlgorithm = Vault.defaultAlgorithm

  //swiftlint:disable all
  private var spyContext: LAContextProtocolSpy!
  private var spyVault: VaultProtocolSpy!
  private var repository: PepperRepositoryProtocol!
  //swiftlint:enable all

}
