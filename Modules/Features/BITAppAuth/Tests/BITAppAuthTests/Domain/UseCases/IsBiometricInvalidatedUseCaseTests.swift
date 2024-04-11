import BITCore
import Foundation
import XCTest

@testable import BITAppAuth

// MARK: - ValidateBiometricUseCaseTests

final class IsBiometricInvalidatedUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyIsBiometricUsageAllowed = IsBiometricUsageAllowedUseCaseProtocolSpy()
    spyHasBiometricAuth = HasBiometricAuthUseCaseProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()

    useCase = IsBiometricInvalidatedUseCase(
      isBiometricUsageAllowed: spyIsBiometricUsageAllowed,
      hasBiometricAuth: spyHasBiometricAuth,
      uniquePassphraseManager: spyUniquePassphraseManager)
  }

  func testBiometricAreValid() {
    spyUniquePassphraseManager.existsForReturnValue = true
    spyIsBiometricUsageAllowed.executeReturnValue = true
    spyHasBiometricAuth.executeReturnValue = true

    let isInvalidated = useCase.execute()
    XCTAssertFalse(isInvalidated)
    XCTAssertTrue(spyUniquePassphraseManager.existsForCalled)
    XCTAssertTrue(spyIsBiometricUsageAllowed.executeCalled)
    XCTAssertTrue(spyHasBiometricAuth.executeCalled)
  }

  func testBiometricInvalid_uniquePassphraseMissing() {
    spyUniquePassphraseManager.existsForReturnValue = false
    spyIsBiometricUsageAllowed.executeReturnValue = true
    spyHasBiometricAuth.executeReturnValue = true

    let isInvalidated = useCase.execute()
    XCTAssertTrue(isInvalidated)
    XCTAssertTrue(spyUniquePassphraseManager.existsForCalled)
    XCTAssertTrue(spyIsBiometricUsageAllowed.executeCalled)
    XCTAssertTrue(spyHasBiometricAuth.executeCalled)
  }

  func testBiometricAreValid_isBiometricUsageForbidden() {
    spyUniquePassphraseManager.existsForReturnValue = true
    spyIsBiometricUsageAllowed.executeReturnValue = false
    spyHasBiometricAuth.executeReturnValue = true

    let isInvalidated = useCase.execute()
    XCTAssertFalse(isInvalidated)
    XCTAssertTrue(spyUniquePassphraseManager.existsForCalled)
    XCTAssertTrue(spyIsBiometricUsageAllowed.executeCalled)
    XCTAssertFalse(spyHasBiometricAuth.executeCalled)
  }

  func testBiometricAreValid_hasNoBiometricAuth() {
    spyUniquePassphraseManager.existsForReturnValue = true
    spyIsBiometricUsageAllowed.executeReturnValue = true
    spyHasBiometricAuth.executeReturnValue = false

    let isInvalidated = useCase.execute()
    XCTAssertFalse(isInvalidated)
    XCTAssertTrue(spyUniquePassphraseManager.existsForCalled)
    XCTAssertTrue(spyIsBiometricUsageAllowed.executeCalled)
    XCTAssertTrue(spyHasBiometricAuth.executeCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: IsBiometricInvalidatedUseCase!
  private var spyIsBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocolSpy!
  private var spyHasBiometricAuth: HasBiometricAuthUseCaseProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  // swiftlint:enable all

}
