import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

// MARK: - UnlockWalletUseCaseTests

final class UnlockWalletUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    processInfoService = ProcessInfoServiceProtocolSpy()
    vault = VaultProtocolSpy()
    let repository = SecretsRepository(vault: vault, processInfoService: processInfoService)
    useCase = UnlockWalletUseCase(repository: repository)
  }

  func testUnlockWallet() throws {
    try useCase.execute()

    vault.saveSecretForKeyClosure = { value, _ in
      XCTAssertNil(value)
    }

    XCTAssertTrue(vault.deleteSecretForCalled)
    XCTAssertEqual(vault.deleteSecretForCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: UnlockWalletUseCase!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var vault: VaultProtocolSpy!
  // swiftlint:enable all

}
