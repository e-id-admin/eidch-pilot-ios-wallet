import BITLocalAuthentication
import Foundation

// MARK: - Encryption/Decryption

extension Vault {

  public func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data {
    let key = try getPublicKey(withIdentifier: identifier, context: context, reason: reason)
    return try encrypt(data: data, usingPublicKey: key, algorithm: algorithm)
  }

  public func encrypt(data: Data, usingPublicKey key: SecKey, algorithm: VaultAlgorithm = defaultAlgorithm) throws -> Data {
    if !SecKeyIsAlgorithmSupported(key, .encrypt, algorithm.encryptionAlgorithm) {
      throw VaultError.algorithmNotSupported
    }

    var error: Unmanaged<CFError>?
    guard let encryptedData = SecKeyCreateEncryptedData(key, algorithm.encryptionAlgorithm, data as CFData, &error) else {
      let errorDescription = (error?.takeRetainedValue() as Error?)?.localizedDescription ?? "Unknown error"
      throw VaultError.encryptionError(errorDescription)
    }

    return encryptedData as Data
  }

  public func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data {
    let key = try getPrivateKey(withIdentifier: identifier, context: context, reason: reason)
    return try decrypt(data: data, usingPrivateKey: key, algorithm: algorithm)
  }

  public func decrypt(data: Data, usingPrivateKey key: SecKey, algorithm: VaultAlgorithm = defaultAlgorithm) throws -> Data {
    if !SecKeyIsAlgorithmSupported(key, .decrypt, algorithm.encryptionAlgorithm) {
      throw VaultError.algorithmNotSupported
    }

    var error: Unmanaged<CFError>?
    guard let decryptedData = SecKeyCreateDecryptedData(key, algorithm.encryptionAlgorithm, data as CFData, &error) else {
      let errorDescription = (error?.takeRetainedValue() as Error?)?.localizedDescription ?? "Unknown error"
      throw VaultError.decryptionError(errorDescription)
    }

    return decryptedData as Data
  }
}
