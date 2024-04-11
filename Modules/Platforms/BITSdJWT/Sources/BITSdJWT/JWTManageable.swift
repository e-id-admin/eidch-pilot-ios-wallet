import Foundation
import Spyable

@Spyable
public protocol JWTManageable {
  func createJWK(from publicKey: SecKey) throws -> JWK
  func createSecKeyFromECKey(curve: String, x: String, y: String) throws -> SecKey
  func createJWT(payloadData: Data, algorithm: JWTAlgorithm, did: String, privateKey: SecKey) throws -> JWT
  func hasValidSignature(jwt: JWT, publicKey: SecKey) -> Bool
}
