import BITSdJWT
import Factory
import Foundation

// MARK: - CredentialJWTGeneratorError

enum CredentialJWTGeneratorError: Error {
  case unsupportedAlgorithm
}

// MARK: - CredentialJWTGenerator

struct CredentialJWTGenerator: CredentialJWTGeneratorProtocol {

  // MARK: Lifecycle

  init(jwtManager: JWTManageable = Container.shared.jwtManager()) {
    self.jwtManager = jwtManager
  }

  // MARK: Internal

  func generate(credentialIssuer: String, didJwk: DidJwk, algorithm: String, privateKey: SecKey, nounce: String) throws -> JWT {
    guard let jwtAlgorithm = JWTAlgorithm(rawValue: algorithm) else {
      throw CredentialJWTGeneratorError.unsupportedAlgorithm
    }
    let jwtPayload = JWTPayload(audience: credentialIssuer, nonce: nounce)
    let payloadData = try JSONEncoder().encode(jwtPayload)
    return try jwtManager.createJWT(
      payloadData: payloadData,
      algorithm: jwtAlgorithm,
      did: didJwk,
      privateKey: privateKey)
  }

  // MARK: Private

  private let jwtManager: JWTManageable
}
