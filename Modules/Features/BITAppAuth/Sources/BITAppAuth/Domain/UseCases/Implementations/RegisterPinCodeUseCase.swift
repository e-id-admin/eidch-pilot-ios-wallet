import BITCrypto
import BITLocalAuthentication
import Factory
import Foundation

public class RegisterPinCodeUseCase: RegisterPinCodeUseCaseProtocol {

  // MARK: Lifecycle

  public init(
    pinCodeManager: PinCodeManagerProtocol = Container.shared.pinCodeManager(),
    pepperService: PepperServiceProtocol = Container.shared.pepperService(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol = Container.shared.isBiometricUsageAllowedUseCase(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.pinCodeManager = pinCodeManager
    self.pepperService = pepperService
    self.uniquePassphraseManager = uniquePassphraseManager
    self.contextManager = contextManager
    self.context = context
    self.isBiometricUsageAllowedUseCase = isBiometricUsageAllowedUseCase
  }

  // MARK: Public

  public func execute(pinCode: PinCode) throws {
    try pinCodeManager.validateRegistration(pinCode)

    try pepperService.generatePepper()
    let pinCodeDataEncrypted = try pinCodeManager.encrypt(pinCode)
    try contextManager.setCredential(pinCodeDataEncrypted, context: context)

    let uniquePassphraseData = try uniquePassphraseManager.generate()
    try saveUniquePassphrase(uniquePassphraseData, context: context)
    try contextManager.setCredential(uniquePassphraseData, context: context)
  }

  // MARK: Private

  private let pinCodeManager: PinCodeManagerProtocol
  private let pepperService: PepperServiceProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocol
  private let contextManager: ContextManagerProtocol
  private let context: LAContextProtocol

  private func saveUniquePassphrase(_ uniquePassphrase: Data, context: LAContextProtocol) throws {
    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .appPin, context: context)

    if isBiometricUsageAllowedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
  }

}
