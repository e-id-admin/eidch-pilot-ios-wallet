import BITAppAuth
import BITCredentialShared
import BITLocalAuthentication
import BITSdJWT
import BITVault
import Factory
import Foundation

// MARK: - PresentationJWTGeneratorError

enum PresentationJWTGeneratorError: Error {
  case invalidAlgorithm
  case claimsMismatch
}

// MARK: - PresentationJWTGenerator

struct PresentationJWTGenerator: PresentationJWTGeneratorProtocol {

  // MARK: Lifecycle

  init(
    keyManager: KeyManagerProtocol = Container.shared.keyManager(),
    jwtManager: JWTManageable = Container.shared.jwtManager(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.keyManager = keyManager
    self.jwtManager = jwtManager
    self.context = context
  }

  // MARK: Internal

  func generate(requestObject: RequestObject, rawCredential: RawCredential, presentationMetadata: PresentationMetadata) throws -> JWT {
    guard let originalSdJWT = SdJWT(from: rawCredential.payload) else { throw SdJWTError.notFound }
    guard let disclosures = getRequiredDisclosures(from: originalSdJWT, considering: presentationMetadata) else { throw PresentationJWTGeneratorError.claimsMismatch }
    guard let presentedSdJWT = SdJWT(from: originalSdJWT.jwt, rawDisclosures: disclosures) else { throw SdJWTError.invalidRawCredentialJWT }

    let verifiableCredential = presentedSdJWT.raw
    let verifiablePresentation = VerifiablePresentation(verifiableCredential: [verifiableCredential])

    guard let algorithm = VaultAlgorithm(rawValue: rawCredential.algorithm) else {
      throw PresentationJWTGeneratorError.invalidAlgorithm
    }

    let query = try QueryBuilder()
      .setContext(context)
      .build()

    let privateKey = try keyManager.getPrivateKey(
      withIdentifier: rawCredential.privateKeyIdentifier.uuidString,
      algorithm: algorithm,
      query: query)
    let publicKey = try keyManager.getPublicKey(for: privateKey)

    let jwk = try jwtManager.createJWK(from: publicKey)
    let didJwk = "did:jwk:\(jwk)"

    let vpJWT = VpJWT(nonce: requestObject.nonce, vp: verifiablePresentation, jti: UUID().uuidString, iss: didJwk)
    let vpJWTData = try JSONEncoder().encode(vpJWT)

    return try jwtManager.createJWT(payloadData: vpJWTData, algorithm: .ES256, did: didJwk, privateKey: privateKey)
  }

  // MARK: Private

  private let keyManager: KeyManagerProtocol
  private let jwtManager: JWTManageable
  private let context: LAContextProtocol

}

extension PresentationJWTGenerator {

  private func getRequiredDisclosures(from sdJWT: SdJWT, considering presentationMetadata: PresentationMetadata) -> String? {
    let claimsKeys = presentationMetadata.attributes.map(\.key)
    let requiredDisclosures: [String] = claimsKeys.compactMap { claimKey in
      sdJWT.claims.first(where: { $0.key == claimKey })?.disclosure
    }
    guard requiredDisclosures.count == claimsKeys.count else { return nil }
    return requiredDisclosures.joined(separator: String(SdJWT.disclosuresSeparator))
  }

}

extension PresentationJWTGenerator {

  struct VerifiablePresentation: Codable {
    var type: [String] = ["VerifiablePresentation"]
    let verifiableCredential: [String]
  }

  struct VpJWT: Codable {
    let nonce: String
    let vp: VerifiablePresentation
    let jti: String
    let iss: String
  }
}
