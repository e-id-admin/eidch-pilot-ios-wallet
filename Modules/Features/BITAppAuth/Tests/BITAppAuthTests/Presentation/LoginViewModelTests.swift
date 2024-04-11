import Combine
import Factory
import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITTestingCore

// MARK: - LoginViewModelTests

@MainActor
final class LoginViewModelTests: XCTestCase {

  // MARK: Internal

  let inputPinCode = "123456"

  override func setUp() {
    super.setUp()
    mockHasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
    mockIsBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
    mockValidatePinCodeUseCase = ValidatePinCodeUseCaseProtocolSpy()
    mockValidateBiometricUseCase = ValidateBiometricUseCaseProtocolSpy()
    mockIsBiometricInvalidatedUseCase = IsBiometricInvalidatedUseCaseProtocolSpy()
    mockLockWalletUseCase = LockWalletUseCaseProtocolSpy()
    mockUnlockWalletUseCase = UnlockWalletUseCaseProtocolSpy()
    mockGetLockedWalletTimeLeftUseCase = GetLockedWalletTimeLeftUseCaseProtocolSpy()
    mockGetLoginAttemptCounterUseCase = GetLoginAttemptCounterUseCaseProtocolSpy()
    mockRegisterLoginAttemptCounterUseCase = RegisterLoginAttemptCounterUseCaseProtocolSpy()
    mockResetLoginAttemptCounterUseCase = ResetLoginAttemptCounterUseCaseProtocolSpy()

    mockHasBiometricAuthUseCase.executeReturnValue = false
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = false
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false

    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = 0

    mockUseCases = LoginUseCasesProtocolSpy()
    mockUseCases.hasBiometricAuth = mockHasBiometricAuthUseCase
    mockUseCases.isBiometricUsageAllowed = mockIsBiometricUsageAllowedUseCase
    mockUseCases.validatePinCode = mockValidatePinCodeUseCase
    mockUseCases.validateBiometric = mockValidateBiometricUseCase
    mockUseCases.isBiometricInvalidatedUseCase = mockIsBiometricInvalidatedUseCase
    mockUseCases.lockWalletUseCase = mockLockWalletUseCase
    mockUseCases.getLockedWalletTimeLeftUseCase = mockGetLockedWalletTimeLeftUseCase
    mockUseCases.unlockWalletUseCase = mockUnlockWalletUseCase
    mockUseCases.getLoginAttemptCounterUseCase = mockGetLoginAttemptCounterUseCase
    mockUseCases.registerLoginAttemptCounterUseCase = mockRegisterLoginAttemptCounterUseCase
    mockUseCases.resetLoginAttemptCounterUseCase = mockResetLoginAttemptCounterUseCase

    isLoginRequiredNotificationTriggered = false
    mockRouter = LoginRouterMock()
  }

  func testValidateProductionValues() {
    let expectedAttemptNumber = 5
    let expectedLockDelay: TimeInterval = 60 * 5
    let expectedPinCodeSize = 6

    let attemptNumber = Container.shared.attemptsLimit()
    let lockDelay = Container.shared.lockDelay()
    let pinCodeSize = Container.shared.pinCodeSize()

    XCTAssertEqual(attemptNumber, expectedAttemptNumber)
    XCTAssertEqual(lockDelay, expectedLockDelay)
    XCTAssertEqual(pinCodeSize, expectedPinCodeSize)
  }

  func testWithInitialData() async {
    let loginRequiredNotificationExpectation = expectation(description: "loginRequiredNotificationExpectation")
    NotificationCenter.default.addObserver(forName: .loginRequired, object: nil, queue: .main) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.isLoginRequiredNotificationTriggered = true
        loginRequiredNotificationExpectation.fulfill()
      }
    }

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, PinCodeState.normal)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)
    XCTAssertFalse(viewModel.isLocked)
    XCTAssertNil(viewModel.countdown)
    XCTAssertNil(viewModel.formattedDateUnlockInterval)

    XCTAssertTrue(mockGetLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindCallsCount, 2)

    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockLockWalletUseCase.executeCalled)

    await fulfillment(of: [loginRequiredNotificationExpectation], timeout: 2)
    XCTAssertTrue(isLoginRequiredNotificationTriggered)
  }

  func testInitLockWithExceededAttempts() async {
    let attemptLimit = 2
    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = attemptLimit
    mockGetLockedWalletTimeLeftUseCase.executeReturnValue = 10
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: attemptLimit)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, PinCodeState.normal)
    XCTAssertEqual(viewModel.attempts, attemptLimit)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)
    XCTAssertTrue(viewModel.isLocked)
    XCTAssertNotNil(viewModel.countdown)
    XCTAssertNotNil(viewModel.formattedDateUnlockInterval)

    XCTAssertTrue(mockGetLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindCallsCount, 2)
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindReceivedInvocations, [.appPin, .biometric])
    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockLockWalletUseCase.executeCalled)
  }

  func testInitLockWithExceededAttemptsButLockTimeIsDone() async {
    let attemptLimit = 2
    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = attemptLimit
    mockGetLockedWalletTimeLeftUseCase.executeReturnValue = -10
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: attemptLimit)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, PinCodeState.normal)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)
    XCTAssertFalse(viewModel.isLocked)
    XCTAssertNil(viewModel.countdown)
    XCTAssertNil(viewModel.formattedDateUnlockInterval)

    XCTAssertTrue(mockGetLoginAttemptCounterUseCase.executeKindCalled)
    // 2 call in the configure
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindCallsCount, 2)

    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertTrue(mockResetLoginAttemptCounterUseCase.executeCalled)
    XCTAssertFalse(mockLockWalletUseCase.executeCalled)
  }

  func testRestartTimerAfterRebootWithTooManyAttempts() async {
    let attemptLimit = 2
    let lockDelay: TimeInterval = 10
    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = attemptLimit
    mockGetLockedWalletTimeLeftUseCase.executeClosure = {
      self.mockGetLockedWalletTimeLeftUseCase.executeCallsCount == 1 ? 100000 : lockDelay
      // 100000 simulates a reboot value. So the first call on getLockedWallet (in configure will return 100000 aka a reboot)
    }
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: attemptLimit, lockDelay: lockDelay)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, PinCodeState.normal)
    XCTAssertEqual(viewModel.attempts, attemptLimit)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)
    XCTAssertTrue(viewModel.isLocked)
    XCTAssertNotNil(viewModel.countdown)
    XCTAssertEqual(viewModel.countdown, lockDelay)

    XCTAssertTrue(mockGetLoginAttemptCounterUseCase.executeKindCalled)
    // 2 call in the configure
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindCallsCount, 2)

    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeCalled)
    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
  }

  func testRestartTimerAfterReboot() async {
    let attemptLimit = 2
    let lockDelay: TimeInterval = 10
    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = attemptLimit
    mockGetLockedWalletTimeLeftUseCase.executeClosure = {
      self.mockGetLockedWalletTimeLeftUseCase.executeCallsCount == 1 ? 100000 : lockDelay
      // 100000 simulates a reboot value. So the first call on getLockedWallet (in configure will return 100000 aka a reboot)
    }
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: attemptLimit, lockDelay: lockDelay)
    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.pinCodeState, PinCodeState.normal)
    XCTAssertEqual(viewModel.attempts, attemptLimit)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)
    XCTAssertTrue(viewModel.isLocked)
    XCTAssertNotNil(viewModel.countdown)
    XCTAssertEqual(viewModel.countdown, lockDelay)

    XCTAssertTrue(mockGetLoginAttemptCounterUseCase.executeKindCalled)
    // 2 call in the configure
    XCTAssertEqual(mockGetLoginAttemptCounterUseCase.executeKindCallsCount, 2)

    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertFalse(mockResetLoginAttemptCounterUseCase.executeCalled)
    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
  }

  func testPinCodeHappyPath() async {
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    viewModel.pinCode = inputPinCode

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertTrue(mockRouter.didCallCloseOnComplete)

    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertEqual(mockValidatePinCodeUseCase.executeFromCallsCount, 1)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(1, mockIsBiometricUsageAllowedUseCase.executeCallsCount)
    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
  }

  func testCloseWhenUnlockFails() async {
    mockUnlockWalletUseCase.executeThrowableError = TestingError.error

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    viewModel.pinCode = inputPinCode

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    XCTAssertFalse(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertTrue(mockRouter.didCallCloseOnComplete)

    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertEqual(mockValidatePinCodeUseCase.executeFromCallsCount, 1)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(1, mockIsBiometricUsageAllowedUseCase.executeCallsCount)
    XCTAssertFalse(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
  }

  func testPinCodeAttemptFailure() async {
    mockRegisterLoginAttemptCounterUseCase.executeKindReturnValue = 1
    let viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await attemptWithFailure(viewModel: viewModel)
  }

  func testPinCodeAttemptFailure_thenSuccess() async {
    mockRegisterLoginAttemptCounterUseCase.executeKindReturnValue = 1
    mockGetLoginAttemptCounterUseCase.executeKindReturnValue = 1
    let viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await attemptWithFailure(viewModel: viewModel)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 1)

    mockValidatePinCodeUseCase.executeFromThrowableError = nil

    viewModel.pinCode = "123456"

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertTrue(mockRouter.didCallCloseOnComplete)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertFalse(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertEqual(2, mockValidatePinCodeUseCase.executeFromCallsCount)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(1, mockIsBiometricUsageAllowedUseCase.executeCallsCount)
  }

  func testBiometricAuthHappyPath() async throws {
    mockHasBiometricAuthUseCase.executeReturnValue = true
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = true
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await viewModel.biometricAuthentication()

    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertTrue(mockRouter.didCallCloseOnComplete)
    XCTAssertTrue(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertTrue(viewModel.isBiometricTriggered)

    XCTAssertTrue(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertTrue(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(1, mockValidateBiometricUseCase.executeCallsCount) // because of the configure in init
  }

  func testBiometricAttemptFailure_deviceHasBiometric() async {
    mockHasBiometricAuthUseCase.executeReturnValue = false
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = true
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await viewModel.biometricAuthentication()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertTrue(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
  }

  func testBiometricAttemptFailure_biometricNotAllowed() async {
    mockHasBiometricAuthUseCase.executeReturnValue = true
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = false
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await viewModel.biometricAuthentication()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertFalse(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
  }

  func testBiometricAttemptFailure_invalidatedData() async {
    mockHasBiometricAuthUseCase.executeReturnValue = true
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = true
    mockIsBiometricInvalidatedUseCase.executeReturnValue = true

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await viewModel.biometricAuthentication()

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertTrue(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
  }

  func testBiometricAttemptFailure() async {
    mockHasBiometricAuthUseCase.executeReturnValue = true
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = true
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false
    mockValidateBiometricUseCase.executeThrowableError = TestingError.error
    mockRegisterLoginAttemptCounterUseCase.executeKindReturnValue = 1

    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases)
    await viewModel.biometricAuthentication()

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertEqual(viewModel.biometricAttempts, 1)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertTrue(viewModel.isBiometricAuthenticationAvailable)
    XCTAssertFalse(viewModel.isBiometricTriggered)

    XCTAssertTrue(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(mockValidateBiometricUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertTrue(mockRegisterLoginAttemptCounterUseCase.executeKindCalled)
    XCTAssertEqual(mockRegisterLoginAttemptCounterUseCase.executeKindCallsCount, 1)
  }

  func testLockedState() async {
    let maxAttempts = 3
    let delay: TimeInterval = 5
    await lockedState(maxAttempts: maxAttempts, delay: delay)

    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
    XCTAssertEqual(mockLockWalletUseCase.executeCallsCount, 1)
    XCTAssertTrue(viewModel.isLocked)
    XCTAssertEqual(viewModel.biometricAttempts, 0)
    XCTAssertEqual(viewModel.attempts, maxAttempts)
    XCTAssertEqual(mockRegisterLoginAttemptCounterUseCase.executeKindCallsCount, maxAttempts)
  }

  func testLockedStateMoreAttempts() async {
    let maxAttempts = 5
    let delay: TimeInterval = 5
    await lockedState(maxAttempts: maxAttempts, delay: delay)

    XCTAssertTrue(viewModel.isLocked)
    XCTAssertEqual(viewModel.biometricAttempts, 0)
    XCTAssertEqual(viewModel.attempts, maxAttempts)

    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
    XCTAssertEqual(mockLockWalletUseCase.executeCallsCount, 1)
    XCTAssertTrue(mockGetLockedWalletTimeLeftUseCase.executeCalled)
    XCTAssertEqual(mockGetLockedWalletTimeLeftUseCase.executeCallsCount, 2)
    XCTAssertFalse(mockUnlockWalletUseCase.executeCalled)
  }

  func testUnlockedState() async throws {
    let maxAttempts = 3
    let delay: TimeInterval = 3
    await lockedState(maxAttempts: maxAttempts, delay: delay)

    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
    XCTAssertEqual(mockLockWalletUseCase.executeCallsCount, 1)
    XCTAssertTrue(mockGetLockedWalletTimeLeftUseCase.executeCalled)
    XCTAssertEqual(mockGetLockedWalletTimeLeftUseCase.executeCallsCount, 2)
    XCTAssertFalse(mockUnlockWalletUseCase.executeCalled)

    XCTAssertTrue(viewModel.isLocked)
    XCTAssertEqual(viewModel.biometricAttempts, 0)
    XCTAssertEqual(viewModel.attempts, maxAttempts)

    try await Task.sleep(nanoseconds: 4_000_000_000)

    XCTAssertNil(viewModel.countdown)
    XCTAssertFalse(viewModel.isLocked)
    XCTAssertTrue(mockUnlockWalletUseCase.executeCalled)
    XCTAssertEqual(mockUnlockWalletUseCase.executeCallsCount, 1)
  }

  func testBiometricLockAndUnlock() async throws {
    mockHasBiometricAuthUseCase.executeReturnValue = true
    mockIsBiometricUsageAllowedUseCase.executeReturnValue = true
    mockIsBiometricInvalidatedUseCase.executeReturnValue = false

    let maxAttempts = 3
    let delay: TimeInterval = 3
    await biometricLockedState(maxAttempts: maxAttempts, delay: delay)

    XCTAssertTrue(mockLockWalletUseCase.executeCalled)
    XCTAssertEqual(mockLockWalletUseCase.executeCallsCount, 1)
    XCTAssertTrue(mockGetLockedWalletTimeLeftUseCase.executeCalled)
    XCTAssertEqual(mockGetLockedWalletTimeLeftUseCase.executeCallsCount, 2)
    XCTAssertTrue(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(mockValidateBiometricUseCase.executeCallsCount, maxAttempts)

    XCTAssertEqual(viewModel.biometricAttempts, maxAttempts)
    XCTAssertEqual(viewModel.attempts, 0)
    XCTAssertTrue(viewModel.isLocked)

    try await Task.sleep(nanoseconds: 4_000_000_000)

    XCTAssertNil(viewModel.countdown)
    XCTAssertFalse(viewModel.isLocked)
    XCTAssertTrue(mockUnlockWalletUseCase.executeCalled)
    XCTAssertEqual(mockUnlockWalletUseCase.executeCallsCount, 1)
  }

  // MARK: Private

  private var mockHasBiometricAuthUseCase = HasBiometricAuthUseCaseProtocolSpy()
  private var mockIsBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
  private var mockValidatePinCodeUseCase = ValidatePinCodeUseCaseProtocolSpy()
  private var mockValidateBiometricUseCase = ValidateBiometricUseCaseProtocolSpy()
  private var mockIsBiometricInvalidatedUseCase = IsBiometricInvalidatedUseCaseProtocolSpy()
  private var mockLockWalletUseCase = LockWalletUseCaseProtocolSpy()
  private var mockUnlockWalletUseCase = UnlockWalletUseCaseProtocolSpy()
  private var mockGetLockedWalletTimeLeftUseCase = GetLockedWalletTimeLeftUseCaseProtocolSpy()
  private var mockGetLoginAttemptCounterUseCase = GetLoginAttemptCounterUseCaseProtocolSpy()
  private var mockRegisterLoginAttemptCounterUseCase = RegisterLoginAttemptCounterUseCaseProtocolSpy()
  private var mockResetLoginAttemptCounterUseCase = ResetLoginAttemptCounterUseCaseProtocolSpy()
  private var mockUseCases = LoginUseCasesProtocolSpy()
  private var mockRouter = LoginRouterMock()
  private lazy var viewModel = LoginViewModel(routes: mockRouter)
  private var isLoginRequiredNotificationTriggered = false

  private func lockedState(maxAttempts: Int, delay: TimeInterval) async {
    mockGetLockedWalletTimeLeftUseCase.executeReturnValue = nil
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: maxAttempts)
    XCTAssertFalse(mockLockWalletUseCase.executeCalled)
    XCTAssertFalse(mockUnlockWalletUseCase.executeCalled)

    for i in 1...maxAttempts {
      mockRegisterLoginAttemptCounterUseCase.executeKindReturnValue = i
      if i == maxAttempts {
        let timeInterval = delay
        mockGetLockedWalletTimeLeftUseCase.executeReturnValue = timeInterval
        Task { @MainActor in
          let duration = UInt64(timeInterval * 1_000_000_000)
          try? await Task.sleep(nanoseconds: duration)
          mockGetLockedWalletTimeLeftUseCase.executeReturnValue = 0
        }
      }
      await attemptWithFailure(viewModel: viewModel)
      XCTAssertEqual(viewModel.attempts, i)
    }
  }

  private func biometricLockedState(maxAttempts: Int, delay: TimeInterval) async {
    mockGetLockedWalletTimeLeftUseCase.executeReturnValue = nil
    viewModel = LoginViewModel(routes: mockRouter, useCases: mockUseCases, attemptsLimit: maxAttempts)
    XCTAssertFalse(mockLockWalletUseCase.executeCalled)
    XCTAssertFalse(mockUnlockWalletUseCase.executeCalled)

    for i in 1...maxAttempts {
      mockRegisterLoginAttemptCounterUseCase.executeKindReturnValue = i
      if i == maxAttempts {
        let timeInterval = delay
        mockGetLockedWalletTimeLeftUseCase.executeReturnValue = timeInterval
        Task { @MainActor in
          let duration = UInt64(timeInterval * 1_000_000_000)
          try? await Task.sleep(nanoseconds: duration)
          mockGetLockedWalletTimeLeftUseCase.executeReturnValue = 0
        }
      }
      await biometricAttemptFailure(viewModel: viewModel)
      XCTAssertEqual(viewModel.biometricAttempts, i)
    }
  }

  private func biometricAttemptFailure(viewModel: LoginViewModel) async {
    mockValidateBiometricUseCase.executeThrowableError = TestingError.error

    await viewModel.biometricAuthentication()

    XCTAssertTrue(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertTrue(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertTrue(mockValidateBiometricUseCase.executeCalled)
  }

  private func attemptWithFailure(viewModel: LoginViewModel) async {
    mockValidatePinCodeUseCase.executeFromThrowableError = TestingError.error

    viewModel.pinCode = inputPinCode

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    XCTAssertTrue(viewModel.pinCode.isEmpty)
    XCTAssertFalse(mockRouter.didCallClose)
    XCTAssertFalse(viewModel.isBiometricAuthenticationAvailable)

    XCTAssertFalse(mockHasBiometricAuthUseCase.executeCalled)
    XCTAssertTrue(mockIsBiometricUsageAllowedUseCase.executeCalled)
    XCTAssertTrue(mockValidatePinCodeUseCase.executeFromCalled)
    XCTAssertFalse(mockValidateBiometricUseCase.executeCalled)
    XCTAssertEqual(1, mockIsBiometricUsageAllowedUseCase.executeCallsCount)
    XCTAssertFalse(mockIsBiometricInvalidatedUseCase.executeCalled)
  }
}
