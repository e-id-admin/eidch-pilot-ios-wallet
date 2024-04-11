import Foundation
import Spyable

@Spyable
public protocol SdJWTDecoderProtocol {
  func decodeStatus(from jwt: JWT, at index: Int) throws -> Int
  func decodeDigests(from rawCredential: String) throws -> [SdJwtDigest]
  func decodeClaims(from rawCredential: String, digests: [SdJwtDigest]) throws -> [SdJWTClaim]
  func decodeVerifiableCredential(from jwt: JWT) -> SdJWTVc?
  func decodeTimestamp(from jwt: JWT, with key: String) -> Date?
}
