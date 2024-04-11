import Foundation

public struct SdJWTVc: Codable, Equatable {
  public let validUntil: Date?
  public let validFrom: Date?
  public let credentialStatus: [SdJWTCredentialStatus]
  public let type: [String]
}
