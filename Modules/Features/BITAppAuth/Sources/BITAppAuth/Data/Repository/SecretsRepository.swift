import BITCore
import BITCrypto
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - SecretsError

enum SecretsError: Error {
  case dataConversionError
}

// MARK: - SecretsKey

private enum SecretsKey {
  static let uniquePassphraseServiceKey = "uniquePassphraseServiceKey"
  static let pepperAppPinServiceKey = "pepperAppPinServiceKey"
  static let pepperAppPinIdentifierKey: String = "pepperAppPinIdentifierKey"
  static let pepperInitialVectorIdentifierKey: String = "pepperInitialVectorIdentifierKey"
  static let lockedWalletUptime = "lockedWalletUptime"
}

// MARK: - SecretsRepository

struct SecretsRepository {

  // MARK: Lifecycle

  init(vault: VaultProtocol = Container.shared.vault(), processInfoService: ProcessInfoServiceProtocol = Container.shared.processInfoService()) {
    self.vault = vault
    self.processInfoService = processInfoService
  }

  // MARK: Private

  private let vault: VaultProtocol
  private let processInfoService: ProcessInfoServiceProtocol

}

// MARK: LockWalletRepositoryProtocol

extension SecretsRepository: LockWalletRepositoryProtocol {
  func getLockedWalletTimeInterval() -> TimeInterval? {
    vault.double(forKey: SecretsKey.lockedWalletUptime)
  }

  func lockWallet() throws {
    try vault.saveSecret(processInfoService.systemUptime, forKey: SecretsKey.lockedWalletUptime)
  }

  func unlockWallet() throws {
    try vault.deleteSecret(for: SecretsKey.lockedWalletUptime)
  }
}

// MARK: UniquePassphraseRepositoryProtocol

extension SecretsRepository: UniquePassphraseRepositoryProtocol {

  func saveUniquePassphrase(_ data: Data, forAuthMethod authMethod: AuthMethod, inContext context: LAContextProtocol) throws {
    try vault.saveSecret(
      data,
      for: authMethod.identifierKey,
      service: SecretsKey.uniquePassphraseServiceKey,
      accessControlFlags: authMethod.accessControlFlags,
      protection: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      canOverride: true,
      context: context)
  }

  func hasUniquePassphraseSaved(forAuthMethod authMethod: AuthMethod) -> Bool {
    vault.keyExists(authMethod.identifierKey, service: SecretsKey.uniquePassphraseServiceKey)
  }

  func getUniquePassphrase(forAuthMethod authMethod: AuthMethod, inContext context: LAContextProtocol) throws -> Data {
    try vault.getSecret(
      for: authMethod.identifierKey,
      service: SecretsKey.uniquePassphraseServiceKey,
      context: context)
  }

  func deleteBiometricUniquePassphrase() throws {
    try vault.deleteSecret(for: AuthMethod.biometric.identifierKey, service: SecretsKey.uniquePassphraseServiceKey)
  }
}

// MARK: PepperRepositoryProtocol

extension SecretsRepository: PepperRepositoryProtocol {

  func createPepperKey() throws -> SecKey {
    try vault.deletePrivateKey(withIdentifier: SecretsKey.pepperAppPinIdentifierKey, algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM)
    return try vault.generatePrivateKey(
      withIdentifier: SecretsKey.pepperAppPinIdentifierKey,
      algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM,
      accessControlFlags: [.privateKeyUsage],
      protection: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      options: [.secureEnclavePermanently])
  }

  func getPepperKey() throws -> SecKey {
    try vault.getPrivateKey(
      withIdentifier: SecretsKey.pepperAppPinIdentifierKey,
      algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM)
  }

  func setPepperInitialVector(_ initialVector: Data) throws {
    try vault.saveSecret(
      initialVector,
      for: SecretsKey.pepperInitialVectorIdentifierKey,
      service: SecretsKey.pepperAppPinServiceKey,
      accessControlFlags: [],
      protection: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
      canOverride: true)
  }

  func getPepperInitialVector() throws -> Data {
    try vault.getSecret(
      for: SecretsKey.pepperInitialVectorIdentifierKey,
      service: SecretsKey.pepperAppPinServiceKey)
  }

}
