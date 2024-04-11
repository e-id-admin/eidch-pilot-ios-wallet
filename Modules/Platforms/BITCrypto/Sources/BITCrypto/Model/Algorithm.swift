import CryptoKit
import Foundation

// MARK: - Algorithm

public enum Algorithm {
  case sha256
  case sha512
  case aes256
}

// MARK: - AlgorithmError

enum AlgorithmError: Error {
  case unsupportedAlgorithm
}

extension Algorithm {

  // MARK: Public

  public var name: String {
    switch self {
    case .sha256: return "SHA-256"
    case .sha512: return "SHA-512"
    case .aes256: return "AES-256"
    }
  }

  public var derivationAlgorithm: SecKeyAlgorithm {
    switch self {
    case .aes256,
         .sha256: return .ecdhKeyExchangeStandardX963SHA256
    case .sha512: return .ecdhKeyExchangeStandardX963SHA512
    }
  }

  public var numberOfBytes: Int {
    switch self {
    case .aes256,
         .sha256: return 32
    case .sha512: return 64
    }
  }

  public var initialVectorSize: Int {
    switch self {
    case .aes256,
         .sha256: return 12
    default: fatalError("Algorithm \(name) not supported for initial vector")
    }
  }

  // MARK: Internal

  func hash(_ data: Data) -> Data {
    switch self {
    case .sha256:
      return SHA256.hash(data: data).asData
    case .sha512:
      return SHA512.hash(data: data).asData
    default: fatalError("Algorithm \(name) not supported for hashing")
    }
  }

  func encrypt(_ data: Data, with key: SymmetricKey, initialVector: Data? = nil) throws -> Data {
    let nonce: AES.GCM.Nonce = try initialVector.map { try AES.GCM.Nonce(data: $0) } ?? AES.GCM.Nonce()
    switch self {
    case .aes256:
      guard let encryptedData = try AES.GCM.seal(data, using: key, nonce: nonce).combined else {
        throw EncrypterError.sealingError
      }
      return encryptedData
    default: throw AlgorithmError.unsupportedAlgorithm
    }
  }

}
