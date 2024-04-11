import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITSettings

@MainActor
final class PrivacyViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    hasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
    hasBiometricAuthUseCase.executeReturnValue = true

    isBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
    isBiometricUsageAllowedUseCase.executeReturnValue = true

    viewModel = PrivacyViewModel(
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCase)
  }

  func testInitialState() {
    XCTAssertTrue(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isPinCodeChangePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
  }

  func testFetchBiometricStatus_enabled() {
    isBiometricUsageAllowedUseCase.executeReturnValue = true
    hasBiometricAuthUseCase.executeReturnValue = true

    viewModel = PrivacyViewModel(
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCase)

    XCTAssertTrue(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isPinCodeChangePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
  }

  func testFetchBiometricStatus_disabled() {
    isBiometricUsageAllowedUseCase.executeReturnValue = false
    hasBiometricAuthUseCase.executeReturnValue = true

    viewModel = PrivacyViewModel(
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCase)

    XCTAssertFalse(viewModel.isBiometricEnabled)
    XCTAssertFalse(viewModel.isPinCodeChangePresented)
    XCTAssertFalse(viewModel.isBiometricChangeFlowPresented)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
  }

  func testFetchBiometricStatus() {
    viewModel.fetchBiometricStatus()

    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
  }

  func testPresentBiometricChangeFlow() {
    viewModel.presentBiometricChangeFlow()

    XCTAssertTrue(viewModel.isBiometricChangeFlowPresented)
  }

  func testPresentPinChangeFlow() {
    viewModel.presentPinChangeFlow()

    XCTAssertTrue(viewModel.isPinCodeChangePresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PrivacyViewModel!
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocolSpy!
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocolSpy!
  // swiftlint:enable all
}
