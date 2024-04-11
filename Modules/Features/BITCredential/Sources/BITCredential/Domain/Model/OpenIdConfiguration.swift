import BITCore
import Foundation

// MARK: - OpenIdConfiguration

public struct OpenIdConfiguration: Codable, Equatable {

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case issuerEndpoint = "issuer"
    case authorizationEndpoint = "authorization_endpoint"
    case tokenEndpoint = "token_endpoint"
    case userinfoEndpoint = "userinfo_endpoint"
    case registrationEndpoint = "registration_endpoint"
    case jwksURI = "jwks_uri"
    case scopesSupported = "scopes_supported"
    case responseTypesSupported = "response_types_supported"
    case idTokenSigningAlgValuesSupported = "id_token_signing_alg_values_supported"
    case requestURIParameterSupported = "request_uri_parameter_supported"
    case pushedAuthorizationRequestEndpoint = "pushed_authorization_request_endpoint"
  }

  let issuerEndpoint: String
  let authorizationEndpoint: URL
  let tokenEndpoint: URL
  let userinfoEndpoint: URL?
  let registrationEndpoint: URL?
  let jwksURI: URL
  let scopesSupported: String?
  let responseTypesSupported: [String]
  let idTokenSigningAlgValuesSupported: [String]
  let requestURIParameterSupported: Bool
  let pushedAuthorizationRequestEndpoint: String

  // MARK: Private

  private enum DecodingError: Error {
    case invalidURL(String)
  }

}
