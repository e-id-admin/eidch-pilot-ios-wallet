import BITCrypto
import BITLocalAuthentication
import BITVault
import Factory
import LocalAuthentication
import SwiftUI

@MainActor
extension Container {

  // MARK: Public

  public var loginModule: Factory<LoginModule> {
    self { LoginModule() }
  }

  public var noDevicePinCodeModule: ParameterFactory<(() -> Void)?, NoDevicePinCodeModule> {
    self { NoDevicePinCodeModule(onComplete: $0) }
  }

  // MARK: Internal

  var loginViewModel: ParameterFactory<LoginRouter.Routes, LoginViewModel> {
    self { LoginViewModel(routes: $0) }
  }

  var pinCodeChangeFlowViewModel: ParameterFactory<Binding<Bool>, PinCodeChangeFlowViewModel> {
    self { PinCodeChangeFlowViewModel(isPresented: $0) }
  }

  var biometricChangeFlowViewModel: ParameterFactory<(Binding<Bool>, Bool), BiometricChangeFlowViewModel> {
    self { BiometricChangeFlowViewModel(isPresented: $0, isBiometricEnabled: $1) }
  }

  var noDevicePinCodeViewModel: ParameterFactory<NoDevicePinCodeRouter.Routes, NoDevicePinCodeViewModel> {
    self { NoDevicePinCodeViewModel(routes: $0) }
  }

}

extension Container {

  public var loginRouter: Factory<LoginRouter> {
    self { LoginRouter() }
  }

  public var noDevicePinRouter: Factory<NoDevicePinCodeRouter> {
    self { NoDevicePinCodeRouter() }
  }

}

// MARK: - Managers

extension Container {

  // MARK: Public

  public var pinCodeErrorAnimationDuration: Factory<CGFloat> { self { 0.5 } }
  public var awaitTimeBeforeBiometrics: Factory<UInt64> { self { 325_000_000 } }
  public var pinCodeObserverDelay: Factory<CGFloat> { self { 0.1 } }
  public var loginRequiredIntervalThreshold: Factory<TimeInterval> { self { 5 } }
  public var passphraseLength: Factory<Int> { self { 64 } } // 64 bytes = 512 bits
  public var pinCodeSize: Factory<Int> { self { 6 } }
  public var attemptsLimit: Factory<Int> { self { 5 } }
  public var lockDelay: Factory<TimeInterval> { self { 60 * 5 } } // in seconds

  public var pinCodeManager: Factory<PinCodeManagerProtocol> {
    self { PinCodeManager() }
  }

  public var pepperService: Factory<PepperServiceProtocol> {
    self { PepperService() }
  }

  public var uniquePassphraseManager: Factory<UniquePassphraseManagerProtocol> {
    self { UniquePassphraseManager() }
  }

  public var contextManager: Factory<ContextManagerProtocol> {
    self { ContextManager() }
  }

  public var authManager: Factory<AuthManagerProtocol> {
    self { AuthManager(loginRequiredAfterIntervalThreshold: self.loginRequiredIntervalThreshold()) }
  }

  public var localAuthenticationPolicyValidator: Factory<LocalAuthenticationPolicyValidatorProtocol> {
    self { LocalAuthenticationPolicyValidator() }
  }

  public var authContext: Factory<LAContextProtocol> {
    self { LAContext() }.cached
  }

  // MARK: Internal

  var vault: Factory<VaultProtocol> {
    self { Vault() }
  }

  var authCredentialType: Factory<LACredentialType> {
    self { .applicationPassword }
  }

  var hasher: Factory<Encryptable> {
    self { Encrypter(algorithm: self.hashingAlgorithm()) }
  }

  var encrypter: Factory<Encryptable> {
    self { Encrypter(algorithm: self.encryptingAlgorithm()) }
  }

  var hashingAlgorithm: Factory<BITCrypto.Algorithm> {
    self { .sha256 }
  }

  var encryptingAlgorithm: Factory<BITCrypto.Algorithm> {
    self { .aes256 }
  }

}

// MARK: - Repository

extension Container {

  // MARK: Public

  public var biometricRepository: Factory<BiometricRepositoryProtocol> {
    self { UserDefaultBiometricRepository() }
  }

  // MARK: Internal

  var pepperRepository: Factory<PepperRepositoryProtocol> {
    self { self.secretsRepository() }
  }

  var uniquePassphraseRepository: Factory<UniquePassphraseRepositoryProtocol> {
    self { self.secretsRepository() }
  }

  var lockWalletRepository: Factory<LockWalletRepositoryProtocol> {
    self { self.secretsRepository() }
  }

  var loginRepository: Factory<LoginRepositoryProtocol> {
    self { LoginRepository() }
  }

  // MARK: Private

  private var secretsRepository: Factory<SecretsRepository> {
    self { SecretsRepository() }.cached
  }

}

// MARK: - UseCases

extension Container {

  // MARK: Public

  public var hasDevicePinUseCase: Factory<HasDevicePinUseCaseProtocol> {
    self { HasDevicePinUseCase() }
  }

  public var hasBiometricAuthUseCase: Factory<HasBiometricAuthUseCaseProtocol> {
    self { HasBiometricAuthUseCase() }
  }

  public var isBiometricUsageAllowedUseCase: Factory<IsBiometricUsageAllowedUseCaseProtocol> {
    self { IsBiometricUsageAllowedUseCase() }
  }

  public var registerPinCodeUseCase: Factory<RegisterPinCodeUseCaseProtocol> {
    self { RegisterPinCodeUseCase() }
  }

  public var getBiometricTypeUseCase: Factory<GetBiometricTypeUseCaseProtocol> {
    self { GetBiometricTypeUseCase() }
  }

  public var requestBiometricAuthUseCase: Factory<RequestBiometricAuthUseCaseProtocol> {
    self { RequestBiometricAuthUseCase() }
  }

  public var allowBiometricUsageUseCase: Factory<AllowBiometricUsageUseCaseProtocol> {
    self { AllowBiometricUsageUseCase() }
  }

  public var updatePinCodeUseCase: Factory<UpdatePinCodeUseCaseProtocol> {
    self { UpdatePinCodeUseCase() }
  }

  public var getUniquePassphraseUseCase: Factory<GetUniquePassphraseUseCaseProtocol> {
    self { GetUniquePassphraseUseCase() }
  }

  public var loginUseCases: Factory<LoginUseCasesProtocol> {
    self {
      LoginUseCases(
        isBiometricUsageAllowed: self.isBiometricUsageAllowedUseCase(),
        hasBiometricAuth: self.hasBiometricAuthUseCase(),
        validatePinCode: self.validatePinCodeUseCase(),
        validateBiometric: self.validateBiometricUseCase(),
        isBiometricInvalidatedUseCase: self.isBiometricInvalidatedUseCase(),
        lockWalletUseCase: self.lockWalletUseCase(),
        unlockWalletUseCase: self.unlockWalletUseCase(),
        getLockedWalletTimeLeftUseCase: self.getLockedWalletTimeLeftUseCase(),
        getLoginAttemptCounterUseCase: self.getLoginAttemptCounterUseCase(),
        registerLoginAttemptCounterUseCase: self.registerLoginAttemptCounterUseCase(),
        resetLoginAttemptCounterUseCase: self.resetLoginAttemptCounterUseCase())
    }
  }

  public var resetLoginAttemptCounterUseCase: Factory<ResetLoginAttemptCounterUseCaseProtocol> {
    self { ResetLoginAttemptCounterUseCase() }
  }

  public var unlockWalletUseCase: Factory<UnlockWalletUseCaseProtocol> {
    self { UnlockWalletUseCase() }
  }

  // MARK: Internal

  var validatePinCodeUseCase: Factory<ValidatePinCodeUseCaseProtocol> {
    self { ValidatePinCodeUseCase() }
  }

  var validateBiometricUseCase: Factory<ValidateBiometricUseCaseProtocol> {
    self { ValidateBiometricUseCase() }
  }

  var changeBiometricStatusUseCase: Factory<ChangeBiometricStatusUseCaseProtocol> {
    self { ChangeBiometricStatusUseCase() }
  }

  var isBiometricInvalidatedUseCase: Factory<IsBiometricInvalidatedUseCaseProtocol> {
    self { IsBiometricInvalidatedUseCase() }
  }

  var lockWalletUseCase: Factory<LockWalletUseCaseProtocol> {
    self { LockWalletUseCase() }
  }

  var getLockedWalletTimeLeftUseCase: Factory<GetLockedWalletTimeLeftUseCaseProtocol> {
    self { GetLockedWalletTimeLeftUseCase() }
  }

  var getLoginAttemptCounterUseCase: Factory<GetLoginAttemptCounterUseCaseProtocol> {
    self { GetLoginAttemptCounterUseCase() }
  }

  var registerLoginAttemptCounterUseCase: Factory<RegisterLoginAttemptCounterUseCaseProtocol> {
    self { RegisterLoginAttemptCounterUseCase() }
  }

}
