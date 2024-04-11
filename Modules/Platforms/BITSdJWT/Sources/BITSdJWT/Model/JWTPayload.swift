import BITCore
import Foundation

// MARK: - JWTPayload

public struct JWTPayload: Codable, Equatable {
  public let audience: String
  public let nonce: String
  public let issueAt: UInt64?

  public init(audience: String, nonce: String, issueAt: UInt64? = nil) {
    self.audience = audience
    self.nonce = nonce
    self.issueAt = issueAt
  }

  enum CodingKeys: String, CodingKey {
    case audience = "aud"
    case nonce
    case issueAt = "iat"
  }
}
