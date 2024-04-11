import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

final class LoginRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    vault = VaultProtocolSpy()
    repository = LoginRepository(vault: vault)
  }

  func testRegisterAttempt() throws {
    let attempt = 2
    vault.saveSecretForKeyClosure = { _, _ in }

    try repository.registerAttempt(attempt, kind: .appPin)
    XCTAssertTrue(vault.saveSecretForKeyCalled)
    XCTAssertEqual(attempt, vault.saveSecretForKeyReceivedArguments?.value as? Int)
    XCTAssertEqual(vault.saveSecretForKeyCallsCount, 1)
  }

  func testReset() throws {
    var biometricAttempts = 2
    let pinAttempts = 3

    vault.saveSecretForKeyClosure = { _, key in
      if key == AuthMethod.biometric.attemptKey {
        biometricAttempts = 0
      }
    }

    try repository.registerAttempt(biometricAttempts, kind: .biometric)
    try repository.resetAttempts(kind: .biometric)

    XCTAssertEqual(biometricAttempts, 0)
    XCTAssertEqual(pinAttempts, 3)

    XCTAssertTrue(vault.saveSecretForKeyCalled)
    XCTAssertEqual(vault.saveSecretForKeyCallsCount, 2)
  }

  func testGetAttempt() throws {
    let attempt = 42
    vault.intForKeyReturnValue = attempt

    try XCTAssertEqual(repository.getAttempts(kind: .biometric), attempt)
    try XCTAssertEqual(repository.getAttempts(kind: .appPin), attempt)
    XCTAssertEqual(vault.intForKeyCallsCount, 2)
    XCTAssertEqual(vault.intForKeyReceivedInvocations, [AuthMethod.biometric.attemptKey, AuthMethod.appPin.attemptKey])
  }

  // MARK: Private

  //swiftlint:disable all
  private var vault: VaultProtocolSpy!
  private var repository: LoginRepositoryProtocol!
  //swiftlint:enable all

}
