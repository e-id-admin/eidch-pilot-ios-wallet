import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

final class LockWalletRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    vault = VaultProtocolSpy()
    processInfoService = ProcessInfoServiceProtocolSpy()
    repository = SecretsRepository(vault: vault, processInfoService: processInfoService)
  }

  func testLockWallet() throws {
    let timeInterval: TimeInterval = 100
    processInfoService.systemUptime = timeInterval

    vault.saveSecretForKeyClosure = { value, _ in
      guard let value = value as? Double else { return XCTFail("Expected a Double") }
      XCTAssertEqual(value, timeInterval)
    }

    try repository.lockWallet()
    XCTAssertTrue(vault.saveSecretForKeyCalled)
    XCTAssertEqual(vault.saveSecretForKeyCallsCount, 1)
  }

  func testUnlockWallet() throws {
    let timeInterval: TimeInterval = 100
    processInfoService.systemUptime = timeInterval

    vault.saveSecretForKeyClosure = { value, _ in
      XCTAssertNil(value)
    }

    try repository.unlockWallet()
    XCTAssertTrue(vault.deleteSecretForCalled)
    XCTAssertEqual(vault.deleteSecretForCallsCount, 1)
  }

  func testTimeIntervalLockWallet() {
    let timeInterval: TimeInterval = 100
    vault.doubleForKeyReturnValue = timeInterval

    let value = repository.getLockedWalletTimeInterval()
    XCTAssertEqual(value, timeInterval)

    XCTAssertTrue(vault.doubleForKeyCalled)
    XCTAssertEqual(vault.doubleForKeyCallsCount, 1)
    XCTAssertFalse(vault.deleteSecretForServiceCalled)
    XCTAssertFalse(vault.saveSecretForKeyCalled)
  }

  func testNoTimeIntervalLockWallet() {
    vault.doubleForKeyReturnValue = nil

    let value = repository.getLockedWalletTimeInterval()
    XCTAssertNil(value)

    XCTAssertTrue(vault.doubleForKeyCalled)
    XCTAssertEqual(vault.doubleForKeyCallsCount, 1)
    XCTAssertFalse(vault.deleteSecretForServiceCalled)
    XCTAssertFalse(vault.saveSecretForKeyCalled)
  }

  // MARK: Private

  //swiftlint:disable all
  private var vault: VaultProtocolSpy!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var repository: LockWalletRepositoryProtocol!
  //swiftlint:enable all

}
