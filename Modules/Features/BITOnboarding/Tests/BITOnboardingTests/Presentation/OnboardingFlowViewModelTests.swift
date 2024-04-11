import Factory
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITOnboarding

@MainActor
final class OnboardingFlowViewModelTests: XCTestCase {

  // MARK: Public

  public override func setUp() {
    super.setUp()
    registerPinCodeUseCase = RegisterPinCodeUseCaseProtocolSpy()
    hasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
    hasBiometricAuthUseCase.executeReturnValue = true
    getBiometricTypeUseCase = GetBiometricTypeUseCaseProtocolSpy()
    getBiometricTypeUseCase.executeReturnValue = .faceID
    requestBiometricAuthUseCase = RequestBiometricAuthUseCaseProtocolSpy()
    allowBiometricUsageUseCase = AllowBiometricUsageUseCaseProtocolSpy()
    onboardingSuccessUseCase = OnboardingSuccessUseCaseProtocolSpy()

    viewModel = OnboardingFlowViewModel(
      routes: OnboardingRouter(),
      getBiometricTypeUseCase: getBiometricTypeUseCase,
      hasBiometricAuthUseCase: hasBiometricAuthUseCase,
      registerPinCodeUseCase: registerPinCodeUseCase,
      requestBiometricAuthUseCase: requestBiometricAuthUseCase,
      allowBiometricUsageUseCase: allowBiometricUsageUseCase,
      onboardingSuccessUseCase: onboardingSuccessUseCase)
  }

  // MARK: Internal

  func testWithInitialData() {
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.wallet.rawValue)
    XCTAssertTrue(viewModel.isSwipeEnabled)
    XCTAssertTrue(viewModel.isNextButtonEnabled)
    XCTAssertEqual(viewModel.pageCount, OnboardingFlowViewModel.Step.allCases.count)
    XCTAssertTrue(viewModel.pin.isEmpty)
    XCTAssertTrue(viewModel.confirmationPin.isEmpty)
    XCTAssertEqual(viewModel.pinConfirmationState, .normal)
    XCTAssertEqual(viewModel.biometricType, .faceID)
    XCTAssertTrue(viewModel.hasBiometricAuth)

    XCTAssertFalse(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertFalse(requestBiometricAuthUseCase.executeReasonContextCalled)
    XCTAssertFalse(allowBiometricUsageUseCase.executeAllowCalled)
    XCTAssertFalse(onboardingSuccessUseCase.executeCalled)
    XCTAssertTrue(getBiometricTypeUseCase.executeCalled)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
  }

  func testInitStepQrCode() {
    viewModel.currentIndex = OnboardingFlowViewModel.Step.qrCode.rawValue
    XCTAssertTrue(viewModel.isSwipeEnabled)
    XCTAssertTrue(viewModel.isNextButtonEnabled)
  }

  func testInitStepPrivacy() {
    viewModel.currentIndex = OnboardingFlowViewModel.Step.privacy.rawValue
    XCTAssertTrue(viewModel.isSwipeEnabled)
    XCTAssertTrue(viewModel.isNextButtonEnabled)
  }

  func testInitStepPin() {
    viewModel.currentIndex = OnboardingFlowViewModel.Step.pin.rawValue
    XCTAssertFalse(viewModel.isSwipeEnabled)
    XCTAssertFalse(viewModel.isNextButtonEnabled)
  }

  func testInitStepPinConfirmation() {
    viewModel.currentIndex = OnboardingFlowViewModel.Step.pinConfirmation.rawValue
    XCTAssertFalse(viewModel.isSwipeEnabled)
    XCTAssertFalse(viewModel.isNextButtonEnabled)
  }

  func testInitStepBiometrics() {
    viewModel.currentIndex = OnboardingFlowViewModel.Step.biometrics.rawValue
    XCTAssertFalse(viewModel.isSwipeEnabled)
    XCTAssertFalse(viewModel.isNextButtonEnabled)
  }

  func test_skipToPrivacyStepFromWallet() {
    to(step: OnboardingFlowViewModel.Step.wallet, viewModel: viewModel)
    viewModel.skipToPrivacyStep()
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.privacy.rawValue)
  }

  func test_skipToPrivacyStepFromQrCode() {
    to(step: OnboardingFlowViewModel.Step.qrCode, viewModel: viewModel)
    viewModel.skipToPrivacyStep()
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.privacy.rawValue)
  }

  func test_skipToPrivacyStepFromPin() {
    to(step: OnboardingFlowViewModel.Step.pin, viewModel: viewModel)
    viewModel.skipToPrivacyStep()
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.pin.rawValue)
  }

  func test_skipBiometrics() {
    to(step: OnboardingFlowViewModel.Step.biometrics, viewModel: viewModel)
    viewModel.skipBiometrics()

    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
    XCTAssertTrue(onboardingSuccessUseCase.executeCalled)
    XCTAssertEqual(onboardingSuccessUseCase.executeCallsCount, 1)
  }

  func test_pinToConfirmation() async throws {
    hasBiometricAuthUseCase.executeReturnValue = true
    to(step: OnboardingFlowViewModel.Step.pin, viewModel: viewModel)
    viewModel.pin = "1234"
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.pin.rawValue)

    viewModel.pin = pin
    try await Task.sleep(nanoseconds: 1_100_000_000) // As the VM makes a delay on the user Input when there is 6 characters entered (currently 0.4s delay)
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.pinConfirmation.rawValue)
  }

  func test_pinConfirmation() async throws {
    try await test_pinToConfirmation()

    viewModel.confirmationPin = pin
    try await Task.sleep(nanoseconds: 1_100_000_000)
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.biometrics.rawValue)
  }

  func test_pinConfirmation_withoutBiometrics() async throws {
    try await test_pinToConfirmation()
    hasBiometricAuthUseCase.executeReturnValue = false

    viewModel.confirmationPin = pin
    try await Task.sleep(nanoseconds: 1_100_000_000)
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.biometrics.rawValue)
  }

  func test_pinConfirmation1Failure() async throws {
    try await test_pinToConfirmation()

    viewModel.confirmationPin = "123412"
    try await Task.sleep(nanoseconds: 1_100_000_000)
    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.pinConfirmation.rawValue)
  }

  func test_pinConfirmationMultipleFailure_thenBackToPin() async throws {
    try await test_pinToConfirmation()

    viewModel.confirmationPin = "123412"
    try await Task.sleep(nanoseconds: 1_100_000_000)

    viewModel.confirmationPin = "123411"
    try await Task.sleep(nanoseconds: 1_100_000_000)

    viewModel.confirmationPin = "123451"
    try await Task.sleep(nanoseconds: 1_100_000_000)

    viewModel.confirmationPin = "123451"
    try await Task.sleep(nanoseconds: 1_100_000_000)

    viewModel.confirmationPin = "123451"
    try await Task.sleep(nanoseconds: 2_000_000_000)

    XCTAssertEqual(viewModel.currentIndex, OnboardingFlowViewModel.Step.pin.rawValue)
  }

  func test_registerBiometrics() async throws {
    to(step: OnboardingFlowViewModel.Step.biometrics, viewModel: viewModel)
    viewModel.registerBiometrics = true
    try await Task.sleep(nanoseconds: 500_000_000)

    XCTAssertTrue(requestBiometricAuthUseCase.executeReasonContextCalled)
    XCTAssertEqual(requestBiometricAuthUseCase.executeReasonContextCallsCount, 1)
    XCTAssertTrue(allowBiometricUsageUseCase.executeAllowCalled)
    XCTAssertEqual(allowBiometricUsageUseCase.executeAllowCallsCount, 1)
    XCTAssertTrue(registerPinCodeUseCase.executePinCodeCalled)
    XCTAssertEqual(registerPinCodeUseCase.executePinCodeCallsCount, 1)
    XCTAssertTrue(onboardingSuccessUseCase.executeCalled)
    XCTAssertEqual(onboardingSuccessUseCase.executeCallsCount, 1)
    XCTAssertTrue(getBiometricTypeUseCase.executeCalled)
    XCTAssertEqual(getBiometricTypeUseCase.executeCallsCount, 1)
    XCTAssertTrue(hasBiometricAuthUseCase.executeCalled)
    XCTAssertEqual(hasBiometricAuthUseCase.executeCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocolSpy!
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocolSpy!
  private var getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocolSpy!
  private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocolSpy!
  private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocolSpy!
  private var onboardingSuccessUseCase: OnboardingSuccessUseCaseProtocolSpy!
  private var viewModel: OnboardingFlowViewModel!

  private let pin: PinCode = "123456"

  // swiftlint:enable all

  private func to(step: OnboardingFlowViewModel.Step, viewModel: OnboardingFlowViewModel) {
    viewModel.currentIndex = step.rawValue
    XCTAssertEqual(viewModel.currentIndex, step.rawValue)
  }

}
