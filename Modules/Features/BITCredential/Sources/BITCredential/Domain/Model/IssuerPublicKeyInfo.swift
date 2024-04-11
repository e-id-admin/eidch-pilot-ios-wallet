import BITCore
import Foundation

// MARK: - IssuerPublicKeyInfo

/// https://jwkset.com
public struct IssuerPublicKeyInfo: Codable {

  let jwks: [JWK]

  enum CodingKeys: String, CodingKey {
    case jwks = "keys"
  }

  /// https://www.rfc-editor.org/rfc/rfc7517.html
  /// https://www.rfc-editor.org/rfc/rfc8037.html
  struct JWK: Codable {
    let kty: String
    let kid: String
    let crv: String
    let x: String
    let y: String
  }

}
