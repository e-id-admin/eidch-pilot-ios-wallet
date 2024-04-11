import BITCore
import BITSdJWT
import Foundation

// MARK: - FetchCredentialResponse

/// The type of object received by the Issuer endpoint
public struct FetchCredentialResponse: Codable {

  // MARK: Lifecycle

  public init(rawCredential: String, format: String) {
    self.rawCredential = rawCredential
    self.format = format
    rawJWT = rawCredential.asRawJWT()
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let rawCredential = try container.decode(String.self, forKey: .rawCredential)
    let format = try container.decode(String.self, forKey: .format)
    self.init(rawCredential: rawCredential, format: format)
  }

  // MARK: Public

  /// The rawCredential without any treatment
  public let rawCredential: String

  /// The format of the credential received like 'jwt_vc'
  public let format: String

  /// The rawCredential processed to keep only the JWT "header.payload.signature".
  /// e.g. for an SD-JWT, the disclosures after the "~" will have been removed.
  public let rawJWT: String?

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case rawCredential = "credential"
    case format
    case rawJWT
  }

}

extension String {
  fileprivate func asRawJWT() -> String? {
    let jwt = separatedByDisclosures.first.map(String.init) ?? self
    guard jwt.split(separator: ".").count == 3 else { return nil }
    return jwt
  }
}
