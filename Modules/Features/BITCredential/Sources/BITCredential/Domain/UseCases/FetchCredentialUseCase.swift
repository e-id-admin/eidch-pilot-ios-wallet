import BITCredentialShared
import BITNetworking
import BITSdJWT
import Factory
import Foundation

// MARK: - FetchCredentialError

public enum FetchCredentialError: Error {
  case unsupportedAlgorithm
  case credentialEndpointCreationError
  case expiredInvitation
}

// MARK: - FetchCredentialUseCase

struct FetchCredentialUseCase: FetchCredentialUseCaseProtocol {

  // MARK: Lifecycle

  init(
    credentialJWTGenerator: CredentialJWTGeneratorProtocol = Container.shared.credentialJWTGenerator(),
    credentialDidJWKGenerator: CredentialDidJWKGeneratorProtocol = Container.shared.credentialDidJWKGenerator(),
    credentialKeyPairGenerator: CredentialKeyPairGeneratorProtocol = Container.shared.credentialKeyPairGenerator(),
    credentialJWTValidator: CredentialJWTValidatorProtocol = Container.shared.credentialJWTValidator(),
    repository: CredentialRepositoryProtocol = Container.shared.apiCredentialRepository())
  {
    self.credentialJWTGenerator = credentialJWTGenerator
    self.credentialDidJWKGenerator = credentialDidJWKGenerator
    self.credentialKeyPairGenerator = credentialKeyPairGenerator
    self.credentialJWTValidator = credentialJWTValidator
    self.repository = repository
  }

  // MARK: Internal

  func execute(from issuerUrl: URL, metadataWrapper: CredentialMetadataWrapper, credentialOffer: CredentialOffer, accessToken: AccessToken?) async throws -> SdJWT {
    guard let credentialEndpoint = URL(string: metadataWrapper.credentialMetadata.credentialEndpoint) else {
      throw FetchCredentialError.credentialEndpointCreationError
    }
    guard let credentialFormat = metadataWrapper.selectedCredential?.format else {
      throw CredentialError.selectedCredentialNotFound
    }

    let configuration = try await repository.fetchOpenIdConfiguration(from: issuerUrl)
    let algorithm = try getAlgorithm(from: metadataWrapper)
    let privateKey = try credentialKeyPairGenerator.generate(identifier: metadataWrapper.privateKeyIdentifier, algorithm: algorithm)
    let didJwk = try credentialDidJWKGenerator.generate(from: metadataWrapper, privateKey: privateKey)
    let retrievedAccessToken = try await fetchAccessToken(considering: accessToken, tokenEndpoint: configuration.tokenEndpoint, credentialOffer: credentialOffer)
    let jwt = try credentialJWTGenerator.generate(
      credentialIssuer: metadataWrapper.credentialMetadata.credentialIssuer,
      didJwk: didJwk,
      algorithm: algorithm,
      privateKey: privateKey,
      nounce: retrievedAccessToken.nounce)

    let credentialBody = CredentialRequestBody(
      format: credentialFormat,
      proof: CredentialRequestProof(jwt: jwt.raw, proofType: "jwt"),
      credentialDefinition: CredentialRequestBodyDefinition(types: credentialOffer.credentials))
    let credentialResponse = try await repository.fetchCredential(
      from: credentialEndpoint,
      credentialRequestBody: credentialBody,
      acccessToken: retrievedAccessToken)

    let issuerPublicKeyInfo = try await repository.fetchIssuerPublicKeyInfo(from: configuration.jwksURI)
    return try await credentialJWTValidator.validate(credentialResponse, withPublicKeyInfo: issuerPublicKeyInfo, selectedCredential: metadataWrapper.selectedCredential)
  }

  // MARK: Private

  private let credentialJWTGenerator: CredentialJWTGeneratorProtocol
  private let credentialDidJWKGenerator: CredentialDidJWKGeneratorProtocol
  private let credentialKeyPairGenerator: CredentialKeyPairGeneratorProtocol
  private let credentialJWTValidator: CredentialJWTValidatorProtocol
  private let repository: CredentialRepositoryProtocol
}

extension FetchCredentialUseCase {

  private func getAlgorithm(from metadataWrapper: CredentialMetadataWrapper) throws -> String {
    guard
      let algorithmsSupported = metadataWrapper.selectedCredential?.cryptographicSuitesSupported,
      let algorithm = selectAlgorithm(from: algorithmsSupported)
    else { throw FetchCredentialError.unsupportedAlgorithm }
    return algorithm
  }

  /// Search for ES256 in priority so we can use SecureEnclave
  private func selectAlgorithm(from supportedAlgorithms: [String]) -> String? {
    guard let es256Algorithm = supportedAlgorithms.first(where: { $0 == JWTAlgorithm.ES256.rawValue }) else {
      return nil
    }
    return es256Algorithm
  }

  private func fetchAccessToken(considering accessToken: AccessToken?, tokenEndpoint: URL, credentialOffer: CredentialOffer) async throws -> AccessToken {
    if let accessToken {
      return accessToken
    }
    do {
      return try await repository.fetchAccessToken(from: tokenEndpoint, preAuthorizedCode: credentialOffer.preAuthorizedCode)
    } catch {
      guard let err = error as? NetworkError, err.status == .invalidGrant else { throw error }
      throw FetchCredentialError.expiredInvitation
    }
  }

}
