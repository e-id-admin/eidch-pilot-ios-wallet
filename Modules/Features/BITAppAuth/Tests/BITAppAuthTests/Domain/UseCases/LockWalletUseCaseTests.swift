import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

// MARK: - LockWalletUseCaseTests

final class LockWalletUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    processInfoService = ProcessInfoServiceProtocolSpy()
    vault = VaultProtocolSpy()
    let repository = SecretsRepository(vault: vault, processInfoService: processInfoService)
    useCase = LockWalletUseCase(repository: repository)
  }

  func testLockWallet() throws {
    processInfoService.systemUptime = timeInterval
    try useCase.execute()

    vault.saveSecretForKeyClosure = { value, _ in
      guard let value = value as? TimeInterval else { return XCTFail("Expected a TimeInterval...") }
      XCTAssertEqual(value, self.timeInterval)
    }

    XCTAssertTrue(vault.saveSecretForKeyCalled)
    XCTAssertEqual(vault.saveSecretForKeyCallsCount, 1)
  }

  // MARK: Private

  private let timeInterval: TimeInterval = 1000

  // swiftlint:disable all
  private var useCase: LockWalletUseCase!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var vault: VaultProtocolSpy!
  // swiftlint:enable all

}
