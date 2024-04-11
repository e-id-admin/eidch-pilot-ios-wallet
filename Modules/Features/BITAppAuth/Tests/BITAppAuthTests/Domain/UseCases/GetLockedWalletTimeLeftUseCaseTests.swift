import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITCore
@testable import BITVault

// MARK: - GetLockedWalletTimeLeftUseCaseTests

final class GetLockedWalletTimeLeftUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    processInfoService = ProcessInfoServiceProtocolSpy()
    vault = VaultProtocolSpy()
    let repository = SecretsRepository(vault: vault, processInfoService: processInfoService)
    useCase = GetLockedWalletTimeLeftUseCase(lockDelay: delay, repository: repository, processInfoService: processInfoService)
  }

  func testGetTimeLeft() throws {
    processInfoService.systemUptime = timeInterval
    vault.doubleForKeyReturnValue = timeInterval
    let time = useCase.execute()

    // result should be the delay as the vault and the processInfo returns 1000.
    XCTAssertEqual(time, delay)
    XCTAssertTrue(vault.doubleForKeyCalled)
    XCTAssertEqual(vault.doubleForKeyCallsCount, 1)
  }

  // MARK: Private

  private let timeInterval: TimeInterval = 1000
  private let delay: TimeInterval = 5

  // swiftlint:disable all
  private var useCase: GetLockedWalletTimeLeftUseCase!
  private var processInfoService: ProcessInfoServiceProtocolSpy!
  private var vault: VaultProtocolSpy!
  // swiftlint:enable all

}
