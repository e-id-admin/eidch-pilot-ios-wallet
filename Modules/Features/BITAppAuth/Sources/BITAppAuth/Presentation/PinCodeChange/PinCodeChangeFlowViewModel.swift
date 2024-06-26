import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - PinCodeChangeStep

public enum PinCodeChangeStep: Int, CaseIterable {
  case currentPin = 0
  case newPin
  case newPinConfirmation
}

// MARK: - PinCodeChangeFlowViewModel

@MainActor
public class PinCodeChangeFlowViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    isPresented: Binding<Bool> = .constant(true),
    updatePinCodeUseCase: UpdatePinCodeUseCaseProtocol = Container.shared.updatePinCodeUseCase(),
    getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol = Container.shared.getUniquePassphraseUseCase())
  {
    _isPresented = isPresented
    self.updatePinCodeUseCase = updatePinCodeUseCase
    self.getUniquePassphraseUseCase = getUniquePassphraseUseCase

    configureBindings()
  }

  // MARK: Public

  @Binding public var isPresented: Bool

  // MARK: Internal

  @Published var currentIndex: Int = 0

  @Published var currentPinCode: String = ""
  @Published var currentPinCodeState: PinCodeState = .normal

  @Published var newPinCode: String = ""
  @Published var newPinCodeConfirmation: String = ""
  @Published var newPinCodeConfirmationState: PinCodeState = .normal

  func backToPin() {
    newPinCode = ""
    newPinCodeConfirmation = ""
    currentIndex = PinCodeChangeStep.newPin.rawValue
    attempts = 0
  }

  // MARK: Private

  private var attempts: Int = 0
  private var bag = Set<AnyCancellable>()
  private let pinCodeSize: Int = Container.shared.pinCodeSize()
  private let pinCodeObserverDelay: CGFloat = Container.shared.pinCodeObserverDelay()
  private var uniquePassphrase: Data? = nil
  private let updatePinCodeUseCase: UpdatePinCodeUseCaseProtocol
  private let getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol

  private func configureBindings() {
    $currentPinCode
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.setCurrentPinCode(value)
      }.store(in: &bag)

    $newPinCode
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.setNewPinCode(value)
      }.store(in: &bag)

    $newPinCodeConfirmation
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        self?.updatePinCode(value, with: self?.uniquePassphrase)
      }.store(in: &bag)
  }

  private func setCurrentPinCode(_ pin: PinCode) {
    guard !pin.isEmpty, pin.count == pinCodeSize else {
      return
    }

    do {
      uniquePassphrase = try getUniquePassphraseUseCase.execute(from: pin)
      currentIndex = PinCodeChangeStep.newPin.rawValue
    } catch {
      handleError(for: .currentPin)
    }
  }

  private func setNewPinCode(_ pin: PinCode) {
    guard !pin.isEmpty, pin.count == pinCodeSize else {
      return
    }

    currentIndex = PinCodeChangeStep.newPinConfirmation.rawValue
  }

  private func updatePinCode(_ pinCode: PinCode, with uniquePassphrase: Data?) {
    guard let uniquePassphrase, pinCode == newPinCode else {
      handleError(for: .newPinConfirmation)
      return
    }

    do {
      try updatePinCodeUseCase.execute(with: pinCode, and: uniquePassphrase)
      isPresented = false
    } catch {
      handleError(for: .newPinConfirmation)
    }
  }

  private func handleError(for step: PinCodeChangeStep, _ duration: Double = Container.shared.pinCodeErrorAnimationDuration()) {
    withAnimation(.easeInOut(duration: duration)) {
      switch step {
      case .currentPin:
        self.currentPinCodeState = .error
      case .newPinConfirmation:
        self.newPinCodeConfirmationState = .error
      default: ()
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      withAnimation {
        switch step {
        case .currentPin:
          self.currentPinCode = ""
          self.currentPinCodeState = .normal
        case .newPinConfirmation:
          self.newPinCodeConfirmation = ""
          self.newPinCodeConfirmationState = .normal
          self.attempts += 1

          if self.attempts == 3 {
            self.backToPin()
          }
        default: ()
        }
      }
    }
  }
}
