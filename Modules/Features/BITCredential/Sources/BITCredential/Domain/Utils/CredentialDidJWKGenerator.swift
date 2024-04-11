import BITSdJWT
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialDidJWKGenerator: CredentialDidJWKGeneratorProtocol {

  // MARK: Lifecycle

  init(
    jwtManager: JWTManageable = Container.shared.jwtManager(),
    vault: VaultProtocol = Container.shared.vault())
  {
    self.jwtManager = jwtManager
    self.vault = vault
  }

  // MARK: Internal

  func generate(from metadataWrapper: CredentialMetadataWrapper, privateKey: SecKey) throws -> DidJwk {
    let publicKey = try vault.getPublicKey(for: privateKey)
    let jwk = try jwtManager.createJWK(from: publicKey)
    let prefix = metadataWrapper.selectedCredential?.cryptographicBindingMethodsSupported?.first
    return "\(prefix ?? Self.defaultJwkDid):\(jwk)"
  }

  // MARK: Private

  private static let defaultJwkDid: String = "did:jwk"

  private let jwtManager: JWTManageable
  private let vault: VaultProtocol
}
