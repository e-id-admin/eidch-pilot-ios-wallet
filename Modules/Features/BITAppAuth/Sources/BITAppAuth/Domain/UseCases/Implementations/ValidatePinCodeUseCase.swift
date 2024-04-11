import BITLocalAuthentication
import Factory
import Foundation

struct ValidatePinCodeUseCase: ValidatePinCodeUseCaseProtocol {

  // MARK: Lifecycle

  init(
    getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol = Container.shared.getUniquePassphraseUseCase(),
    isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol = Container.shared.isBiometricInvalidatedUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.getUniquePassphraseUseCase = getUniquePassphraseUseCase
    self.isBiometricInvalidatedUseCase = isBiometricInvalidatedUseCase
    self.uniquePassphraseManager = uniquePassphraseManager
    self.context = context
  }

  // MARK: Internal

  func execute(from pinCode: PinCode) throws {
    let uniquePassphrase = try getUniquePassphraseUseCase.execute(from: pinCode)
    if isBiometricInvalidatedUseCase.execute() {
      try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, for: .biometric, context: context)
    }
  }

  // MARK: Private

  private let getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol
  private let isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let context: LAContextProtocol
}
