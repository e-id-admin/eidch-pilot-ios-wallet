import BITLocalAuthentication
import Factory
import Foundation

// MARK: - ValidateBiometricUseCase

class ValidateBiometricUseCase: ValidateBiometricUseCaseProtocol {

  // MARK: Lifecycle

  init(
    requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol = Container.shared.requestBiometricAuthUseCase(),
    uniquePassphraseManager: UniquePassphraseManagerProtocol = Container.shared.uniquePassphraseManager(),
    contextManager: ContextManagerProtocol = Container.shared.contextManager(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.requestBiometricAuthUseCase = requestBiometricAuthUseCase
    self.uniquePassphraseManager = uniquePassphraseManager
    self.contextManager = contextManager
    self.context = context
  }

  // MARK: Internal

  func execute() async throws {
    try await requestBiometricAuthUseCase.execute(reason: L10n.biometricSetupReason, context: context)
    let uniquePassphraseData = try uniquePassphraseManager.getUniquePassphrase(authMethod: .biometric, context: context)
    try contextManager.setCredential(uniquePassphraseData, context: context)
  }

  // MARK: Private

  private let requestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol
  private let uniquePassphraseManager: UniquePassphraseManagerProtocol
  private let contextManager: ContextManagerProtocol
  private let context: LAContextProtocol
}
