import CryptoKit
import Foundation

// MARK: - EncrypterError

enum EncrypterError: Error {
  case publicKeyRetrievalError
  case keyCopyExchangeResultError(errorDerive: Unmanaged<CFError>?)
  case sealingError
}

// MARK: - Encrypter

public struct Encrypter: Encryptable {

  // MARK: Lifecycle

  public init(algorithm: Algorithm) {
    self.algorithm = algorithm
  }

  // MARK: Public

  public private(set) var algorithm: Algorithm

  public func generateRandomBytes(length: Int) throws -> Data {
    try Data.random(length: length)
  }

  public func hash(data: Data, withSalt salt: Data? = nil) throws -> Data {
    guard let salt else {
      return algorithm.hash(data)
    }
    return algorithm.hash(Data.combine(data, with: salt))
  }

  public func encryptWithDerivedKey(fromPrivateKey privateKey: SecKey, data: Data, initialVector: Data?) throws -> Data {
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw EncrypterError.publicKeyRetrievalError
    }
    let derivedKey: SymmetricKey = try generateSymmetricKey(fromPrivateKey: privateKey, publicKey: publicKey)
    return try algorithm.encrypt(data, with: derivedKey, initialVector: initialVector)
  }

}

extension Encrypter {

  private func generateSymmetricKey(fromPrivateKey privateKey: SecKey, publicKey: SecKey) throws -> SymmetricKey {
    var errorDerive: Unmanaged<CFError>?
    let parameters: [String: Any] = [
      SecKeyKeyExchangeParameter.requestedSize.rawValue as String: algorithm.numberOfBytes,
    ]
    guard
      let sharedSecret = SecKeyCopyKeyExchangeResult(
        privateKey,
        algorithm.derivationAlgorithm,
        publicKey,
        parameters as CFDictionary,
        &errorDerive) else
    {
      throw EncrypterError.keyCopyExchangeResultError(errorDerive: errorDerive)
    }

    let derivedData = sharedSecret as Data
    return SymmetricKey(data: derivedData.prefix(algorithm.numberOfBytes))
  }
}
