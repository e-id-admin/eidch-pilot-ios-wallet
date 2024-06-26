import BITCredentialShared
import BITSdJWT
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialDidJWKGenerator: CredentialDidJWKGeneratorProtocol {

  // MARK: Lifecycle

  init(
    jwtManager: JWTManageable = Container.shared.jwtManager(),
    keyManager: KeyManagerProtocol = Container.shared.keyManager())
  {
    self.jwtManager = jwtManager
    self.keyManager = keyManager
  }

  // MARK: Internal

  func generate(from metadataWrapper: CredentialMetadataWrapper, privateKey: SecKey) throws -> DidJwk {
    let publicKey = try keyManager.getPublicKey(for: privateKey)
    let jwk = try jwtManager.createJWK(from: publicKey)
    let prefix = metadataWrapper.selectedCredential?.cryptographicBindingMethodsSupported?.first
    return "\(prefix ?? Self.defaultJwkDid):\(jwk)"
  }

  // MARK: Private

  private static let defaultJwkDid: String = "did:jwk"

  private let jwtManager: JWTManageable
  private let keyManager: KeyManagerProtocol
}
