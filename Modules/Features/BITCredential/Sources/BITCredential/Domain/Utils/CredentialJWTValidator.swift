import BITSdJWT
import Factory
import Foundation

// MARK: - CredentialJWTValidatorError

public enum CredentialJWTValidatorError: Error {
  case credentialMismatch
  case invalidSignature
  case invalidJWT
  case invalidSdJWT
}

// MARK: - CredentialJWTValidator

struct CredentialJWTValidator: CredentialJWTValidatorProtocol {

  // MARK: Lifecycle

  init(
    jwtManager: JWTManageable = Container.shared.jwtManager(),
    dateBuffer: TimeInterval = Container.shared.dateBuffer())
  {
    self.jwtManager = jwtManager
    self.dateBuffer = dateBuffer
  }

  // MARK: Internal

  func validate(_ credentialResponse: FetchCredentialResponse, withPublicKeyInfo publicKeyInfo: IssuerPublicKeyInfo, selectedCredential: CredentialMetadata.CredentialsSupported?) async throws -> SdJWT {
    guard
      let rawJWT = credentialResponse.rawJWT,
      await validateJwtSignature(rawJWT, publicKeyInfo: publicKeyInfo) else
    {
      throw CredentialJWTValidatorError.invalidSignature
    }

    guard let sdJWT = validateSdJwtDisclosures(credentialResponse.rawCredential) else {
      throw CredentialJWTValidatorError.invalidSdJWT
    }

    guard validateJwtTimestamps(sdJWT, referenceDate: Date().addingTimeInterval(dateBuffer)) else {
      throw CredentialJWTValidatorError.invalidJWT
    }

    guard validateMandatoryClaims(sdJWT, selectedCredential: selectedCredential) else {
      throw CredentialJWTValidatorError.credentialMismatch
    }
    return sdJWT
  }

  // MARK: Private

  private let jwtManager: JWTManageable
  private let dateBuffer: TimeInterval

}

extension CredentialJWTValidator {

  private func validateJwtSignature(_ rawJWT: String, publicKeyInfo: IssuerPublicKeyInfo) async -> Bool {
    do {
      let jwt = try JWT(raw: rawJWT)
      for jwk in publicKeyInfo.jwks {
        let secKey = try jwtManager.createSecKeyFromECKey(curve: jwk.crv, x: jwk.x, y: jwk.y)
        if jwtManager.hasValidSignature(jwt: jwt, publicKey: secKey) {
          return true
        }
      }
      return false
    } catch {
      return false
    }
  }

  private func validateSdJwtDisclosures(_ rawJWT: String) -> SdJWT? {
    SdJWT(from: rawJWT)
  }

  private func validateJwtTimestamps(_ credential: SdJWT, referenceDate: Date) -> Bool {
    let defaultValue = true // These fields are optional
    let hasBeenIssuedBefore = credential.jwtIssuedAt.map { $0 <= referenceDate } ?? defaultValue
    let hasBeenActivatedBefore = credential.jwtActivatedAt.map { $0 <= referenceDate } ?? defaultValue
    let isNotExpired = credential.jwtExpiredAt.map { $0 >= referenceDate } ?? defaultValue
    return hasBeenIssuedBefore && hasBeenActivatedBefore && isNotExpired
  }

  private func validateMandatoryClaims(_ credential: SdJWT, selectedCredential: CredentialMetadata.CredentialsSupported?) -> Bool {
    guard let selectedCredential else { return false }
    let mandatoryClaims = selectedCredential.credentialDefinition.credentialSubject.filter({ $0.mandatory ?? false })
    guard mandatoryClaims.count <= credential.claims.count else { return false }
    for mandatoryClaim in mandatoryClaims {
      guard credential.claims.first(where: { mandatoryClaim.key == $0.key }) != nil else { return false }
    }

    return true
  }

}
