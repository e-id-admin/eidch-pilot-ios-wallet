import BITCredentialShared
import BITNetworking
import BITSdJWT
import Factory
import Foundation
import Moya

// MARK: - ApiCredentialRepository

struct ApiCredentialRepository {
  private let networkService: NetworkService = NetworkContainer.shared.service()
}

// MARK: CredentialRepositoryProtocol

extension ApiCredentialRepository: CredentialRepositoryProtocol {

  func fetchMetadata(from issuerUrl: URL) async throws -> CredentialMetadata {
    try await networkService.request(CredentialEndpoint.metadata(fromIssuerUrl: issuerUrl))
  }

  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration {
    try await networkService.request(CredentialEndpoint.openIdConfiguration(issuerURL: issuerURL))
  }

  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> IssuerPublicKeyInfo {
    try await networkService.request(CredentialEndpoint.publicKeyInfo(jwksUrl: jwksUrl))
  }

  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken {
    try await networkService.request(CredentialEndpoint.accessToken(fromTokenUrl: url, preAuthorizedCode: preAuthorizedCode))
  }

  func fetchCredential(from url: URL, credentialRequestBody: CredentialRequestBody, acccessToken: AccessToken) async throws -> FetchCredentialResponse {
    try await networkService.request(CredentialEndpoint.credential(url: url, body: credentialRequestBody, acccessToken: acccessToken.accessToken))
  }

  func fetchCredentialStatus(from url: URL) async throws -> JWT {
    let raw: String = try await networkService.request(CredentialEndpoint.status(url: url))
    return try JWT(raw: raw)
  }

}

// MARK: - CRUD

extension ApiCredentialRepository {
  func create(credential: Credential) async throws -> Credential { fatalError("Not usable in that context.") }
  func delete(_ id: UUID) async throws { fatalError("Not usable in that context.") }
  func update(_ credential: Credential) async throws -> Credential { fatalError("Not usable in that context.") }
  func get(id: UUID) async throws -> Credential { fatalError("Not usable in that context.") }
  func getAll() async throws -> [Credential] { fatalError("Not usable in that context.") }
}
