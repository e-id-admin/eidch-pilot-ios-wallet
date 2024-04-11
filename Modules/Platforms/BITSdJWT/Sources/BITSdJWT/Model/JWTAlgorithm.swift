import Foundation

// MARK: - JWTAlgorithm

public enum JWTAlgorithm: String {
  case ES256
  case ES512
}

// MARK: JWTAlgorithm.AlgorithmError

extension JWTAlgorithm {
  enum AlgorithmError: Error {
    case signatureAlgorithmCreationError
  }
}
