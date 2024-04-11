import BITAppAuth
import Factory
import Foundation

class PrivacyViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase())
  {
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase

    fetchBiometricStatus()
  }

  // MARK: Internal

  @Published var isBiometricEnabled: Bool = false
  @Published var isPinCodeChangePresented = false
  @Published var isBiometricChangeFlowPresented: Bool = false

  func fetchBiometricStatus() {
    isBiometricEnabled = (isBiometricUsageAllowedUseCase.execute() && hasBiometricAuthUseCase.execute())
  }

  func presentPinChangeFlow() {
    isPinCodeChangePresented = true
  }

  func presentBiometricChangeFlow() {
    isBiometricChangeFlowPresented = true
  }

  // MARK: Private

  private var hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol

}
