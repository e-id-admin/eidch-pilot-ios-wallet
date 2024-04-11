import BITCore
import Foundation
import JOSESwift

// MARK: - JWT

public struct JWT: Codable, Equatable {

  // MARK: Lifecycle

  public init(raw: String) throws {
    guard let algorithmHeader = JWTDecoder().decodeAlgorithmHeader(from: raw) else {
      throw JWTDecoder.DecoderError.algorithmNotFound
    }
    self.raw = raw
    self.algorithmHeader = algorithmHeader
  }

  // MARK: Public

  public let raw: String
  public let algorithmHeader: String
}
