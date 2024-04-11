import BITCore
import Combine
import Factory
import SwiftUI

// MARK: - LoginViewModel

@MainActor
public class LoginViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    routes: LoginRouter.Routes,
    pinCode: String = "",
    useCases: LoginUseCasesProtocol = Container.shared.loginUseCases(),
    awaitTimeOnAppear: UInt64 = Container.shared.awaitTimeBeforeBiometrics(),
    pinCodeErrorAnimationDuration: CGFloat = Container.shared.pinCodeErrorAnimationDuration(),
    pinCodeObserverDelay: CGFloat = Container.shared.pinCodeObserverDelay(),
    attemptsLimit: Int = Container.shared.attemptsLimit(),
    lockDelay: TimeInterval = Container.shared.lockDelay(),
    pinCodeSize: Int = Container.shared.pinCodeSize())
  {
    self.routes = routes
    self.useCases = useCases
    self.pinCode = pinCode

    self.awaitTimeOnAppear = awaitTimeOnAppear
    self.pinCodeErrorAnimationDuration = pinCodeErrorAnimationDuration
    self.pinCodeObserverDelay = pinCodeObserverDelay
    self.attemptsLimit = attemptsLimit
    self.lockDelay = lockDelay
    self.pinCodeSize = pinCodeSize

    updateBiometricContext()
    configureObservers()
    restoreAttempts()
    evaluateLockedWallet()

    NotificationCenter.default.post(name: .loginRequired, object: nil)
  }

  // MARK: Internal

  @Published var isBiometricAuthenticationAvailable: Bool = false
  @Published var isBiometricTriggered: Bool = false
  @Published var pinCode: PinCode
  @Published var pinCodeState: PinCodeState = .normal
  @Published var biometricAttempts: Int = 0
  @Published var attempts: Int = 0
  @Published var countdown: TimeInterval?

  var formattedDateUnlockInterval: String? {
    guard let countdown else { return nil }
    let date = Date(timeInterval: countdown, since: .now)
    let timeLeft = date.timeIntervalSince(.now)
    return "\(DateComponentsFormatter().string(from: timeLeft) ?? "") \(timeLeft >= 60 ? "min" : "sec")"
  }

  var isLocked: Bool {
    guard let countdown else { return false }
    return countdown >= 1 && countdown <= lockDelay
  }

  func onAppear() {
    Task {
      try? await Task.sleep(nanoseconds: awaitTimeOnAppear)
      await biometricAuthentication()
    }
  }

  // MARK: Private

  private let awaitTimeOnAppear: UInt64
  private let pinCodeErrorAnimationDuration: CGFloat
  private let pinCodeObserverDelay: CGFloat
  private let attemptsLimit: Int
  private let pinCodeSize: Int
  private let lockDelay: TimeInterval

  private var timer: Timer?

  private let routes: LoginRouter.Routes

  private let useCases: LoginUseCasesProtocol
  private var bag = Set<AnyCancellable>()

  private func configureObservers() {
    $pinCode
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.validatePinCode(value)
      }.store(in: &bag)
  }

  private func validatePinCode(_ pin: PinCode) {
    guard (try? useCases.validatePinCode.execute(from: pin)) != nil else {
      return retry()
    }

    unlockApp()
    close()
  }

  private func close() {
    routes.close(onComplete: {
      NotificationCenter.default.post(name: .didLogin, object: nil)
    })
  }

  private func retry() {
    // necessary "hack" with the dispatchQueue to get the "completion" of the animation as we don't have iOS17 min.
    withAnimation(.easeInOut(duration: pinCodeErrorAnimationDuration)) {
      self.pinCodeState = .error
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + pinCodeErrorAnimationDuration) {
      withAnimation {
        self.handleFailedAttempt()
        self.pinCodeState = .normal
      }
    }
  }

  private func handleFailedAttempt() {
    attempts = (try? useCases.registerLoginAttemptCounterUseCase.execute(kind: .appPin)) ?? attempts + 1
    pinCode = ""

    if attempts >= attemptsLimit {
      lockApp()
    }
  }

  private func reset() {
    resetAttempts()
    timer?.invalidate()
    timer = nil
    pinCode = ""
    countdown = nil
  }

  private func resetAttempts() {
    try? useCases.resetLoginAttemptCounterUseCase.execute()
    attempts = 0
    biometricAttempts = 0
  }

}

// MARK: - Lock login

extension LoginViewModel {

  private func startCountdown() {
    guard timer == nil else { return }

    countdown = useCases.getLockedWalletTimeLeftUseCase.execute()

    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
      Task { @MainActor [weak self] in
        guard let self else { return }
        countdown = useCases.getLockedWalletTimeLeftUseCase.execute()
        if !isLocked {
          return unlockApp()
        }
      }
    })
  }

  private func evaluateLockedWallet() {
    countdown = useCases.getLockedWalletTimeLeftUseCase.execute()
    let tooManyAttempts = (attempts >= attemptsLimit || biometricAttempts >= attemptsLimit)

    if isLocked {
      return startCountdown()
    }

    guard let countdown else { return }

    let deviceWasRebooted = countdown > lockDelay && tooManyAttempts
    let countdownFinishedWhenAppKilled = countdown < 1 && tooManyAttempts

    if deviceWasRebooted {
      lockApp() // re-lock the app
    } else if countdownFinishedWhenAppKilled {
      unlockApp()
    }
  }

  private func unlockApp() {
    do {
      try useCases.unlockWalletUseCase.execute()
      reset()
    } catch {}
  }

  private func lockApp() {
    do {
      try useCases.lockWalletUseCase.execute()
      startCountdown()
    } catch {}
  }

  private func restoreAttempts() {
    attempts = (try? useCases.getLoginAttemptCounterUseCase.execute(kind: .appPin)) ?? 0
    biometricAttempts = (try? useCases.getLoginAttemptCounterUseCase.execute(kind: .biometric)) ?? 0
  }

}

extension LoginViewModel {

  // MARK: Internal

  func biometricAuthentication() async {
    guard isBiometricAuthenticationAvailable, !isBiometricTriggered, !isLocked else { return }
    isBiometricTriggered = true
    do {
      try await useCases.validateBiometric.execute()
      reset()
      close()
    } catch {
      if let attempts = try? useCases.registerLoginAttemptCounterUseCase.execute(kind: .biometric) {
        biometricAttempts = attempts
      } else {
        biometricAttempts += 1
      }
      isBiometricTriggered = false

      if biometricAttempts >= attemptsLimit {
        do {
          try useCases.lockWalletUseCase.execute()
          startCountdown()
        } catch {}
      }
    }
  }

  // MARK: Private

  private func updateBiometricContext() {
    isBiometricAuthenticationAvailable = useCases.isBiometricUsageAllowed.execute()
      && useCases.hasBiometricAuth.execute()
      && !useCases.isBiometricInvalidatedUseCase.execute()
  }

}
