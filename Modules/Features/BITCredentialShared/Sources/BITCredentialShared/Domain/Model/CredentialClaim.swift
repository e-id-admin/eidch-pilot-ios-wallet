import BITCore
import BITDataStore
import BITSdJWT
import Foundation

// MARK: - CredentialClaim

public struct CredentialClaim: Codable {

  // MARK: Lifecycle

  init(id: UUID = .init(), key: String, valueType: String = "string", value: String, order: Int16 = 0, credentialId: UUID? = nil, displays: [CredentialClaimDisplay] = []) {
    self.id = id
    self.key = key
    self.valueType = valueType
    self.value = value
    self.order = order
    self.credentialId = credentialId
    self.displays = displays
    preferredDisplay = displays.findDisplayWithFallback() as? CredentialClaimDisplay
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(UUID.self, forKey: .id)
    let key = try container.decode(String.self, forKey: .key)
    let valueType = try container.decode(String.self, forKey: .valueType)
    let value = try container.decode(String.self, forKey: .value)
    let order = try container.decode(Int16.self, forKey: .order)
    let credentialId = try container.decodeIfPresent(UUID.self, forKey: .credentialId)
    let displays = try container.decode([CredentialClaimDisplay].self, forKey: .displays)

    self.init(
      id: id,
      key: key,
      valueType: valueType,
      value: value,
      order: order,
      credentialId: credentialId,
      displays: displays)
  }

  public init(_ entity: CredentialClaimEntity) {
    self.init(
      id: entity.id,
      key: entity.key,
      valueType: entity.valueType,
      value: entity.value,
      order: entity.order,
      credentialId: entity.credential?.id,
      displays: (entity.displays?.allObjects as? [CredentialClaimDisplayEntity])?.map({ .init($0) }) ?? [])
  }

  public init(_ claim: CredentialMetadata.Claim, sdJWTClaim: SdJWTClaim, credentialId: UUID) throws {
    guard let sdJWTClaimValue = sdJWTClaim.value, let valueType = claim.valueType?.rawValue else { throw CredentialClaimError.cannotDecodeClaim }
    let id: UUID = .init()

    self.init(
      id: id,
      key: claim.key,
      valueType: valueType,
      value: sdJWTClaimValue.rawValue,
      order: Int16(claim.order),
      credentialId: credentialId,
      displays: claim.display?.map({ CredentialClaimDisplay($0, claimId: id) }) ?? [])
  }

  // MARK: Public

  public var id: UUID
  public var key: String
  public var valueType: String
  public var value: String
  public var order: Int16
  public var credentialId: UUID?
  public var displays: [CredentialClaimDisplay]
  public var preferredDisplay: CredentialClaimDisplay?

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id
    case key
    case valueType = "value_type"
    case value
    case order
    case credentialId = "credential_id"
    case displays
  }

}

// MARK: - CredentialClaimError

public enum CredentialClaimError: Error {
  case cannotDecodeClaim
  case invalidClaimDisplay
}

// MARK: - CredentialClaim + Equatable

extension CredentialClaim: Equatable {

  public static func == (lhs: CredentialClaim, rhs: CredentialClaim) -> Bool {
    lhs.id == rhs.id &&
      lhs.key == rhs.key &&
      lhs.valueType == rhs.valueType &&
      lhs.value == rhs.value &&
      lhs.order == rhs.order &&
      lhs.credentialId == rhs.credentialId
  }

}
