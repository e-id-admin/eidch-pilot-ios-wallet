import BITSdJWT
import Foundation
import Spyable

// MARK: - CredentialRepositoryProtocol

@Spyable
public protocol CredentialRepositoryProtocol {
  func fetchMetadata(from issuerUrl: URL) async throws -> CredentialMetadata
  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration
  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> IssuerPublicKeyInfo
  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken
  func fetchCredential(from url: URL, credentialRequestBody: CredentialRequestBody, acccessToken: AccessToken) async throws -> FetchCredentialResponse
  func fetchCredentialStatus(from url: URL) async throws -> JWT

  func create(credential: Credential) async throws -> Credential
  func getAll() async throws -> [Credential]
  func get(id: UUID) async throws -> Credential
  @discardableResult
  func update(_ credential: Credential) async throws -> Credential
  func delete(_ id: UUID) async throws
}
