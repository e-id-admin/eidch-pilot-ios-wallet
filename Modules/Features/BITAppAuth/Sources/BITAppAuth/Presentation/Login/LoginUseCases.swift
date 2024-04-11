import Foundation
import Spyable

// MARK: - LoginUseCasesProtocol

@Spyable
public protocol LoginUseCasesProtocol {
  var isBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocol { get }
  var hasBiometricAuth: HasBiometricAuthUseCaseProtocol { get }
  var validatePinCode: ValidatePinCodeUseCaseProtocol { get }
  var validateBiometric: ValidateBiometricUseCaseProtocol { get }
  var isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol { get }
  var lockWalletUseCase: LockWalletUseCaseProtocol { get }
  var unlockWalletUseCase: UnlockWalletUseCaseProtocol { get }
  var getLockedWalletTimeLeftUseCase: GetLockedWalletTimeLeftUseCaseProtocol { get }
  var getLoginAttemptCounterUseCase: GetLoginAttemptCounterUseCaseProtocol { get }
  var registerLoginAttemptCounterUseCase: RegisterLoginAttemptCounterUseCaseProtocol { get }
  var resetLoginAttemptCounterUseCase: ResetLoginAttemptCounterUseCaseProtocol { get }
}

// MARK: - LoginUseCases

struct LoginUseCases: LoginUseCasesProtocol {
  let isBiometricUsageAllowed: IsBiometricUsageAllowedUseCaseProtocol
  let hasBiometricAuth: HasBiometricAuthUseCaseProtocol
  let validatePinCode: ValidatePinCodeUseCaseProtocol
  let validateBiometric: ValidateBiometricUseCaseProtocol
  let isBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocol
  let lockWalletUseCase: LockWalletUseCaseProtocol
  let unlockWalletUseCase: UnlockWalletUseCaseProtocol
  let getLockedWalletTimeLeftUseCase: GetLockedWalletTimeLeftUseCaseProtocol
  let getLoginAttemptCounterUseCase: GetLoginAttemptCounterUseCaseProtocol
  let registerLoginAttemptCounterUseCase: RegisterLoginAttemptCounterUseCaseProtocol
  let resetLoginAttemptCounterUseCase: ResetLoginAttemptCounterUseCaseProtocol
}
