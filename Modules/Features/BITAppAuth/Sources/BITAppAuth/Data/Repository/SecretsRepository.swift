import BITCore
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - SecretsError

enum SecretsError: Error {
  case dataConversionError
  case unavailableData
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

  init(
    keyManager: KeyManagerProtocol = Container.shared.keyManager(),
    secretManager: SecretManagerProtocol = Container.shared.secretManager(),
    processInfoService: ProcessInfoServiceProtocol = Container.shared.processInfoService())
  {
    self.keyManager = keyManager
    self.secretManager = secretManager
    self.processInfoService = processInfoService
  }

  // MARK: Private

  private let secretManager: SecretManagerProtocol
  private let keyManager: KeyManagerProtocol
  private let processInfoService: ProcessInfoServiceProtocol

}

// MARK: LockWalletRepositoryProtocol

extension SecretsRepository: LockWalletRepositoryProtocol {
  func getLockedWalletTimeInterval() -> TimeInterval? {
    secretManager.double(forKey: SecretsKey.lockedWalletUptime)
  }

  func lockWallet() throws {
    try secretManager.set(processInfoService.systemUptime, forKey: SecretsKey.lockedWalletUptime)
  }

  func unlockWallet() throws {
    try secretManager.removeObject(forKey: SecretsKey.lockedWalletUptime)
  }
}

// MARK: UniquePassphraseRepositoryProtocol

extension SecretsRepository: UniquePassphraseRepositoryProtocol {

  func saveUniquePassphrase(_ data: Data, forAuthMethod authMethod: AuthMethod, inContext context: LAContextProtocol) throws {
    let query = try QueryBuilder()
      .setService(SecretsKey.uniquePassphraseServiceKey)
      .setAccessControlFlags(authMethod.accessControlFlags)
      .setProtection(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      .setContext(context)
      .build()

    try secretManager.set(data, forKey: authMethod.identifierKey, query: query)
  }

  func hasUniquePassphraseSaved(forAuthMethod authMethod: AuthMethod) -> Bool {
    do {
      let query = try QueryBuilder()
        .setService(SecretsKey.uniquePassphraseServiceKey)
        .build()

      return secretManager.exists(key: authMethod.identifierKey, query: query)
    } catch {
      return false
    }
  }

  func getUniquePassphrase(forAuthMethod authMethod: AuthMethod, inContext context: LAContextProtocol) throws -> Data {
    let query = try QueryBuilder()
      .setService(SecretsKey.uniquePassphraseServiceKey)
      .setContext(context)
      .build()

    guard let data = secretManager.data(forKey: authMethod.identifierKey, query: query) else {
      throw SecretsError.unavailableData
    }

    return data
  }

  func deleteBiometricUniquePassphrase() throws {
    let query = try QueryBuilder()
      .setService(SecretsKey.uniquePassphraseServiceKey)
      .build()

    try secretManager.removeObject(forKey: AuthMethod.biometric.identifierKey, query: query)
  }
}

// MARK: PepperRepositoryProtocol

extension SecretsRepository: PepperRepositoryProtocol {

  func createPepperKey() throws -> SecKey {
    try keyManager.deleteKeyPair(withIdentifier: SecretsKey.pepperAppPinIdentifierKey, algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM)

    let query = try QueryBuilder()
      .setAccessControlFlags([.privateKeyUsage])
      .setProtection(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      .build()

    return try keyManager.generateKeyPair(
      withIdentifier: SecretsKey.pepperAppPinIdentifierKey,
      algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM,
      options: [.secureEnclavePermanently],
      query: query)
  }

  func getPepperKey() throws -> SecKey {
    try keyManager.getPrivateKey(
      withIdentifier: SecretsKey.pepperAppPinIdentifierKey,
      algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM)
  }

  func setPepperInitialVector(_ initialVector: Data) throws {
    let query = try QueryBuilder()
      .setService(SecretsKey.pepperAppPinServiceKey)
      .setAccessControlFlags([])
      .setProtection(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      .build()

    try secretManager.set(initialVector, forKey: SecretsKey.pepperInitialVectorIdentifierKey, query: query)
  }

  func getPepperInitialVector() throws -> Data {
    let query = try QueryBuilder()
      .setService(SecretsKey.pepperAppPinServiceKey)
      .build()

    guard let data = secretManager.data(forKey: SecretsKey.pepperInitialVectorIdentifierKey, query: query) else {
      throw SecretsError.unavailableData
    }

    return data
  }
}
