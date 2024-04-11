import BITLocalAuthentication
import Foundation

// MARK: - Signing

extension Vault {

  public func sign(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data {
    let privateKey = try getPrivateKey(withIdentifier: identifier, algorithm: algorithm, context: context, reason: reason)
    return try sign(data: data, usingKey: privateKey)
  }

  public func sign(data: Data, usingKey privateKey: SecKey, algorithm: VaultAlgorithm = defaultAlgorithm) throws -> Data {
    if !SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm.signingAlgorithm) {
      throw VaultError.algorithmNotSupported
    }

    var error: Unmanaged<CFError>?
    guard let signature = SecKeyCreateSignature(privateKey, algorithm.signingAlgorithm, data as CFData, &error) else {
      let errorDescription = (error?.takeRetainedValue() as Error?)?.localizedDescription ?? "Unknown error"
      throw VaultError.encryptionError("Signing failed: \(errorDescription)")
    }

    return signature as Data
  }

  public func verify(signature: Data, for data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Bool {
    let publicKey = try getPublicKey(withIdentifier: identifier, context: context, reason: reason)
    return try verify(signature: signature, for: data, usingKey: publicKey)
  }

  public func verify(signature: Data, for data: Data, usingKey publicKey: SecKey, algorithm: VaultAlgorithm = defaultAlgorithm) throws -> Bool {
    if !SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm.signingAlgorithm) {
      throw VaultError.algorithmNotSupported
    }

    var error: Unmanaged<CFError>?
    let isValid = SecKeyVerifySignature(publicKey, algorithm.signingAlgorithm, data as CFData, signature as CFData, &error)

    if let error {
      let errorDescription = error.takeRetainedValue() as Error
      throw VaultError.decryptionError("Verification failed: \(errorDescription.localizedDescription)")
    }

    return isValid
  }

}
