import BITCore
import BITCrypto
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITVault

final class UniquePassphraseRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyContext = LAContextProtocolSpy()
    spyVault = VaultProtocolSpy()
    repository = SecretsRepository(vault: spyVault)
  }

  func testSaveUniquePassphrase_appPin() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .appPin
    try repository.saveUniquePassphrase(mockData, forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertTrue(spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonCalled)
    XCTAssertEqual(mockData, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.data)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.key)
    XCTAssertEqual(AuthMethod.appPin.accessControlFlags, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.accessControlFlags)
    XCTAssertEqual(kSecAttrAccessibleWhenUnlockedThisDeviceOnly, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.protection)
    XCTAssertEqual(true, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.canOverride)
  }

  func testSaveUniquePassphrase_biometric() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .biometric
    try repository.saveUniquePassphrase(mockData, forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertTrue(spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonCalled)
    XCTAssertEqual(mockData, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.data)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.key)
    XCTAssertEqual(AuthMethod.biometric.accessControlFlags, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.accessControlFlags)
    XCTAssertEqual(kSecAttrAccessibleWhenUnlockedThisDeviceOnly, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.protection)
    XCTAssertEqual(true, spyVault.saveSecretForServiceAccessControlFlagsProtectionCanOverrideContextReasonReceivedArguments?.canOverride)
  }

  func testGetUniquePassphrase_appPin() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .appPin
    spyVault.getSecretForServiceContextReasonReturnValue = mockData
    let data = try repository.getUniquePassphrase(forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(spyVault.getSecretForServiceContextReasonCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spyVault.getSecretForServiceContextReasonReceivedArguments?.key)
  }

  func testGetUniquePassphrase_biometric() throws {
    let mockData: Data = .init()
    let appPinAuthMethod: AuthMethod = .biometric
    spyVault.getSecretForServiceContextReasonReturnValue = mockData
    let data = try repository.getUniquePassphrase(forAuthMethod: appPinAuthMethod, inContext: spyContext)
    XCTAssertEqual(mockData, data)
    XCTAssertTrue(spyVault.getSecretForServiceContextReasonCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spyVault.getSecretForServiceContextReasonReceivedArguments?.key)
  }

  func testDeleteBiometricUniquePassphrase() throws {
    try repository.deleteBiometricUniquePassphrase()

    XCTAssertTrue(spyVault.deleteSecretForServiceCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spyVault.deleteSecretForServiceReceivedArguments?.key)
  }

  func testHasUniquePassphrase_appPin() throws {
    spyVault.keyExistsServiceReturnValue = true
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .appPin)
    XCTAssertTrue(hasSecret)
    XCTAssertTrue(spyVault.keyExistsServiceCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spyVault.keyExistsServiceReceivedArguments?.key)
  }

  func testHasUniquePassphrase_biometric() throws {
    spyVault.keyExistsServiceReturnValue = true
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .biometric)
    XCTAssertTrue(hasSecret)
    XCTAssertTrue(spyVault.keyExistsServiceCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spyVault.keyExistsServiceReceivedArguments?.key)
  }

  func testHasNotUniquePassphrase_appPin() throws {
    spyVault.keyExistsServiceReturnValue = false
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .appPin)
    XCTAssertFalse(hasSecret)
    XCTAssertTrue(spyVault.keyExistsServiceCalled)
    XCTAssertEqual(AuthMethod.appPin.identifierKey, spyVault.keyExistsServiceReceivedArguments?.key)
  }

  func testHasNotUniquePassphrase_biometric() throws {
    spyVault.keyExistsServiceReturnValue = false
    let hasSecret = repository.hasUniquePassphraseSaved(forAuthMethod: .biometric)
    XCTAssertFalse(hasSecret)
    XCTAssertTrue(spyVault.keyExistsServiceCalled)
    XCTAssertEqual(AuthMethod.biometric.identifierKey, spyVault.keyExistsServiceReceivedArguments?.key)
  }

  // MARK: Private

  private let vaultAlgorithm: VaultAlgorithm = Vault.defaultAlgorithm

  //swiftlint:disable all
  private var spyContext: LAContextProtocolSpy!
  private var spyVault: VaultProtocolSpy!
  private var repository: UniquePassphraseRepositoryProtocol!
  //swiftlint:enable all

}
