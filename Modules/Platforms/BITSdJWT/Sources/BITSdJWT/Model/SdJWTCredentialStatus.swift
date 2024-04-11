import Foundation

public struct SdJWTCredentialStatus: Codable, Equatable {
  public let id: String
  public let statusListIndex: String
  public let statusPurpose: SdJWTCredentialStatusPurpose

  public enum SdJWTCredentialStatusPurpose: String, Codable {
    case revocation
    case suspension
  }
}
