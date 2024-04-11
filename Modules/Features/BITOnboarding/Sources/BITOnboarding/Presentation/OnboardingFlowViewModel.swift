import BITAppAuth
import BITCore
import BITLocalAuthentication
import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - OnboardingFlowViewModel

@MainActor
public class OnboardingFlowViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    routes: OnboardingRouter.Routes,
    getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol = Container.shared.getBiometricTypeUseCase(),
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    registerPinCodeUseCase: RegisterPinCodeUseCaseProtocol = Container.shared.registerPinCodeUseCase(),
    requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol = Container.shared.requestBiometricAuthUseCase(),
    allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol = Container.shared.allowBiometricUsageUseCase(),
    onboardingSuccessUseCase: OnboardingSuccessUseCaseProtocol = Container.shared.onboardingSuccessUseCase())
  {
    self.routes = routes
    self.getBiometricTypeUseCase = getBiometricTypeUseCase
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.registerPinCodeUseCase = registerPinCodeUseCase
    self.requestBiometricAuthUseCase = requestBiometricAuthUseCase
    self.allowBiometricUsageUseCase = allowBiometricUsageUseCase
    self.onboardingSuccessUseCase = onboardingSuccessUseCase
    biometricType = getBiometricTypeUseCase.execute()
    hasBiometricAuth = hasBiometricAuthUseCase.execute()
    configureObservers()
  }

  // MARK: Internal

  enum Step: Int, CaseIterable {
    case wallet = 0, qrCode, privacy, pin, pinConfirmation, biometrics
  }

  var onComplete: (() -> Void)?
  @Published var pin: String = ""
  @Published var confirmationPin: String = ""
  @Published var pinConfirmationState: PinCodeState = .normal

  @Published var hasBiometricAuth: Bool = false

  let pageCount: Int = Step.allCases.count
  @Published var currentIndex: Int = Step.wallet.rawValue
  @Published var isSwipeEnabled: Bool = true
  @Published var isNextButtonEnabled: Bool = true
  @Published var areDotsEnabled: Bool = true
  @Published var isKeyPadDisabled: Bool = false

  var biometricType: BiometricType

  @Published var registerBiometrics: Bool = false {
    didSet {
      if registerBiometrics {
        Task {
          await processBiometricRegistration()
        }
      }
    }
  }

  func skipToPrivacyStep() {
    guard let step = Step(rawValue: currentIndex) else { return }
    let skippableSteps: [Int] = [Step.wallet, Step.qrCode].map(\.rawValue)
    currentIndex = skippableSteps.contains { $0 == step.rawValue } ? Step.privacy.rawValue : currentIndex
  }

  func skipBiometrics() {
    guard let step = Step(rawValue: currentIndex), step == .biometrics else { return }
    do {
      try done()
    } catch {
      backToPinCode()
    }
  }

  func backToPinCode() {
    pin = ""
    confirmationPin = ""
    currentIndex = Step.pin.rawValue
    pinConfirmationState = .normal
    attempts = 0
    isKeyPadDisabled = false
  }

  // MARK: Private

  private let routes: OnboardingRouter.Routes
  private let pinCodeSize = Container.shared.pinCodeSize()
  private let pinCodeErrorAnimationDuration: CGFloat = Container.shared.pinCodeErrorAnimationDuration()
  private let pinCodeObserverDelay: CGFloat = Container.shared.pinCodeObserverDelay()
  private let attemptsLimit: Int = Container.shared.attemptsLimit()
  private var attempts: Int = 0
  private let context: LAContextProtocol = Container.shared.authContext()

  private var bag = Set<AnyCancellable>()
  private var registerPinCodeUseCase: RegisterPinCodeUseCaseProtocol
  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  private var getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol
  private var requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  private var allowBiometricUsageUseCase: AllowBiometricUsageUseCaseProtocol
  private var onboardingSuccessUseCase: OnboardingSuccessUseCaseProtocol

  private func setPinCode(_ pin: PinCode) {
    guard !pin.isEmpty, pin.count == pinCodeSize else { return }
    currentIndex = Step.pinConfirmation.rawValue
  }

  private func setConfirmationPinCode(_ pin: PinCode) {
    guard !pin.isEmpty, pin.count == pinCodeSize else { return }
    guard self.pin == pin else {
      // necessary "hack" with the dispatchQueue to get the "completion" of the animation as we don't have iOS17 min.
      withAnimation(.easeInOut(duration: pinCodeErrorAnimationDuration)) {
        self.pinConfirmationState = .error
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + pinCodeErrorAnimationDuration) {
        withAnimation {
          self.pinConfirmationState = .normal
          self.confirmationPin = ""
          self.attempts += 1

          if self.attempts == self.attemptsLimit {
            self.backToPinCode()
          }
        }
      }

      return
    }

    currentIndex = Step.biometrics.rawValue
  }

  private func configureObservers() {
    $currentIndex.sink { [weak self] value in
      self?.process(index: value)
    }.store(in: &bag)

    $pin
      .filter { $0.count >= self.pinCodeSize }
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] _ in
        self?.isKeyPadDisabled = true
      }.store(in: &bag)

    $pin
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.setPinCode(value)
      }.store(in: &bag)

    $confirmationPin
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.setConfirmationPinCode(value)
      }.store(in: &bag)

    NotificationCenter.default.addObserver(forName: .willEnterForeground, object: nil, queue: .main) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.checkBiometricStatus()
      }
    }
  }

  private func process(index: Int) {
    guard let step = Step(rawValue: index) else { return }
    switch step {
    case .pin:
      allowNextButton(false)
    case .pinConfirmation:
      guard pin.isEmpty else { return }
      allowNextButton(false)
      currentIndex = Step.pin.rawValue
    case .biometrics:
      guard
        !pin.isEmpty,
        !confirmationPin.isEmpty,
        pin == confirmationPin
      else {
        return currentIndex = Step.pin.rawValue
      }
      allowNextButton(false)
      areDotsEnabled = false
    default:
      allowNextButton(true)
      return
    }
  }

  private func allowNextButton(_ isAllowed: Bool) {
    isSwipeEnabled = isAllowed
    isNextButtonEnabled = isAllowed
  }

  private func processBiometricRegistration() async {
    do {
      try await requestBiometricAuthUseCase.execute(reason: L10n.onboardingBiometricPermissionReason(BiometricStepType(type: biometricType).text), context: context)
      try allowBiometricUsageUseCase.execute(allow: true)
    } catch {}

    do {
      try done()
    } catch {}
  }

  private func done() throws {
    try registerPinCodeUseCase.execute(pinCode: pin)
    try onboardingSuccessUseCase.execute()
    routes.close(onComplete: nil)
    onComplete?()
  }

  private func checkBiometricStatus() {
    guard let currentStep = Step(rawValue: currentIndex), currentStep == .biometrics else {
      return
    }

    hasBiometricAuth = hasBiometricAuthUseCase.execute()
    biometricType = getBiometricTypeUseCase.execute()
  }

}
