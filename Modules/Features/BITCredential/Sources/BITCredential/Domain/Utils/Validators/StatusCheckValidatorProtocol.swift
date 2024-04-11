import BITSdJWT
import Foundation
import Spyable

// MARK: - StatusCheckError

enum StatusCheckError: Error {
  case invalidCredential
  case invalidCredentialStatus
  case unprocessableStatus
}

// MARK: - StatusCheckValidatorProtocol

@Spyable
protocol StatusCheckValidatorProtocol {
  func validate(_ sdJwt: SdJWT) async throws -> Bool
}
