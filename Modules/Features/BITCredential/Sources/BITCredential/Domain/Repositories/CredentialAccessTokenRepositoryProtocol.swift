import Foundation
import Spyable

@Spyable
protocol CredentialAccessTokenRepositoryProtocol {
  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken
  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration
  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> IssuerPublicKeyInfo

}
