import BITCore
import Foundation

// MARK: - AccessToken

public struct AccessToken: Codable {
  let nounce: String
  let accessToken: String

  enum CodingKeys: String, CodingKey {
    case nounce = "c_nonce"
    case accessToken = "access_token"
  }
}
