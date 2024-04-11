import BITCore
import Foundation

// MARK: - SdJWTClaimError

enum SdJWTClaimError: Error {
  case invalidKey, invalidStructure, invalidValueType
}

// MARK: - SdJWTClaim

public struct SdJWTClaim: Equatable, Codable {

  // MARK: Lifecycle

  public init(disclosableClaim: [Any], disclosure: String, digest: SdJwtDigest) throws {
    guard disclosableClaim.count >= 3 else { throw SdJWTClaimError.invalidStructure }
    guard let key = disclosableClaim[1] as? String else { throw SdJWTClaimError.invalidKey }

    self.key = key
    self.digest = digest
    self.disclosure = disclosure
    value = try .init(anyValue: disclosableClaim[2])
  }

  // MARK: Public

  public let digest: SdJwtDigest
  public let key: String
  public var value: CodableValue?
  public let disclosure: String
}

extension SdJWTClaim {
  public func anyValue() throws -> Any {
    switch value {
    case .string(let stringValue): stringValue
    case .int(let intValue): intValue
    case .double(let doubleValue): doubleValue
    case .bool(let boolValue): boolValue
    case .array(let arrayValue): arrayValue
    case .dictionary(let dictionaryValue): dictionaryValue
    case .none: throw SdJWTClaimError.invalidValueType
    }
  }
}

//extension SdJWTClaim {
//  public struct Mock {
//    public static func sample() throws -> SdJWTClaim {
//      try .init(
//        disclosableClaim: [
//          "O5K8hdNAOx5xgWRgLtFWxA",
//          "lastName",
//          "Doo",
//        ],
//        disclosure: "WyJnU3prcGE2cHlEb3ZoMVB1QnN3UEt3IiwgImZpcnN0TmFtZSIsICJGcml0eiJd",
//        digest: "7Hv7YrNvSwfuHXzkv07-q9gsSNLzx9QSXtf0nuzl4Wc")
//    }
//  }
//}
