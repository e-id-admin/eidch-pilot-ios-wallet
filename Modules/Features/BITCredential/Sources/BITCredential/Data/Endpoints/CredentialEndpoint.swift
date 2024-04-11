import BITNetworking
import BITSdJWT
import Foundation
import Moya

// MARK: - CredentialEndpoint

enum CredentialEndpoint {
  case metadata(fromIssuerUrl: URL)
  case credential(url: URL, body: CredentialRequestBody, acccessToken: String)
  case accessToken(fromTokenUrl: URL, preAuthorizedCode: String)
  case openIdConfiguration(issuerURL: URL)
  case status(url: URL)
  case publicKeyInfo(jwksUrl: URL)
}

// MARK: TargetType

extension CredentialEndpoint: TargetType {

  var baseURL: URL {
    switch self {
    case .metadata(let issuerUrl):
      issuerUrl
    case .openIdConfiguration(let issuerURL):
      issuerURL
    case .accessToken(let tokenUrl, _):
      tokenUrl
    case .credential(let credentialURL, _, _):
      credentialURL
    case .status(let url):
      url
    case .publicKeyInfo(let jwksUrl):
      jwksUrl
    }
  }

  var path: String {
    switch self {
    case .metadata:
      "/.well-known/openid-credential-issuer"
    case .openIdConfiguration:
      "/.well-known/openid-configuration"
    case .accessToken,
         .credential,
         .publicKeyInfo,
         .status:
      "" // The path is already included in the baseUrl of the tokenUrl
    }
  }

  var method: Moya.Method {
    switch self {
    case .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .status:
      .get
    case .accessToken,
         .credential:
      .post
    }
  }

  var task: Task {
    switch self {
    case .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .status:
      .requestPlain
    case .accessToken(_, let preAuthorizedCode):
      .requestParameters(parameters: [
        "grant_type": "urn:ietf:params:oauth:grant-type:pre-authorized_code",
        "pre-authorized_code": preAuthorizedCode,
      ], encoding: URLEncoding.queryString)

    case .credential(_, let credentialBody, _):
      .requestParameters(
        parameters: credentialBody.asDictionnary(),
        encoding: JSONEncoding.default)
    }
  }

  var headers: [String: String]? {
    switch self {
    case .accessToken,
         .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .status:
      NetworkHeader.standard.raw
    case .credential(_, _, let token):
      NetworkHeader.authorization(token).raw
    }
  }
}
