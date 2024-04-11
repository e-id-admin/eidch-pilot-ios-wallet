import Foundation
import JOSESwift

// MARK: - JWTManager

public class JWTManager {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public static let defaultAlgorithm: JWTAlgorithm = .ES256

  // MARK: Internal

  enum JWTError: Error {
    case invalidData
    case jwsCreationError
    case verifierCreationError
  }

}

// MARK: JWTManageable

extension JWTManager: JWTManageable {

  public func createJWK(from publicKey: SecKey) throws -> JWK {
    guard
      let jwk = try? ECPublicKey(publicKey: publicKey),
      let json = jwk.jsonString(),
      let jsonBase64 = json.data(using: .utf8)?.base64EncodedString()
    else { throw JWTError.invalidData }
    return jsonBase64
  }

  public func createSecKeyFromECKey(curve: String, x: String, y: String) throws -> SecKey {
    guard let curve = ECCurveType(rawValue: curve) else { throw JWTError.invalidData }
    let publicKey = ECPublicKey(crv: curve, x: x, y: y)
    return try publicKey.converted(to: SecKey.self)
  }

  public func createJWT(payloadData: Data, algorithm: JWTAlgorithm, did: String, privateKey: SecKey) throws -> JWT {
    let signatureAlgorithm: SignatureAlgorithm = try .init(from: algorithm)
    let header = JWSHeader(algorithm: signatureAlgorithm, kid: did, type: "JWT")
    let payload = Payload(payloadData)

    guard
      let signer = Signer(signingAlgorithm: signatureAlgorithm, key: privateKey),
      let jws = try? JWS(header: header, payload: payload, signer: signer)
    else { throw JWTError.jwsCreationError }

    return try JWT(raw: jws.compactSerializedString)
  }

  public func hasValidSignature(jwt: JWT, publicKey: SecKey) -> Bool {
    do {
      let algorithmHeader = jwt.algorithmHeader
      guard let jwtAlgorithm = JWTAlgorithm(rawValue: algorithmHeader) else {
        throw JWTError.verifierCreationError
      }
      let signatureAlgorithm = try SignatureAlgorithm(from: jwtAlgorithm)
      let jws = try JWS(compactSerialization: jwt.raw)

      guard
        let verifier = Verifier(verifyingAlgorithm: signatureAlgorithm, key: publicKey)
      else { throw JWTError.verifierCreationError }
      _ = try jws.validate(using: verifier).payload
      return true
    } catch {
      return false
    }
  }

}
