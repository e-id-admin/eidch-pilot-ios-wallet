import BITCore
import BITDataStore
import Foundation

// MARK: - ActivityVerifierCredentialClaim

public struct ActivityVerifierCredentialClaim: Codable {

  // MARK: Lifecycle

  init?(_ entity: ActivityVerifierCredentialClaimEntity) {
    guard let type = ValueType(rawValue: entity.valueType) else {
      return nil
    }

    self.init(
      id: entity.id,
      key: entity.key,
      value: entity.value,
      valueType: type,
      order: entity.order,
      activityVerifierId: entity.activityVerifier.id,
      displays: (entity.activityVerifierCredentialClaimDisplays.allObjects as? [ActivityVerifierCredentialClaimDisplayEntity])?.compactMap({ .init($0) }) ?? [])
  }

  public init?(id: UUID = UUID(), key: String, value: String, valueType: String, order: Int16, activityVerifierId: UUID, displays: [ActivityVerifierCredentialClaimDisplay] = []) {
    guard let type = ValueType(rawValue: valueType) else {
      return nil
    }

    self.init(id: id, key: key, value: value, valueType: type, order: order, activityVerifierId: activityVerifierId, displays: displays)
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    key = try container.decode(String.self, forKey: .key)
    order = try container.decode(Int16.self, forKey: .order)
    value = try container.decode(String.self, forKey: .value)
    valueType = try container.decode(ValueType.self, forKey: .valueType)
    preferredDisplay = try container.decodeIfPresent(ActivityVerifierCredentialClaimDisplay.self, forKey: .preferredDisplay)
    id = try container.decode(UUID.self, forKey: .id)
    activityVerifierId = try container.decode(UUID.self, forKey: .activityVerifierId)
    displays = try container.decode([ActivityVerifierCredentialClaimDisplay].self, forKey: .displays)
  }

  private init(id: UUID, key: String, value: String, valueType: ValueType, order: Int16, activityVerifierId: UUID, displays: [ActivityVerifierCredentialClaimDisplay]) {
    self.id = id
    self.key = key
    self.value = value
    self.valueType = valueType
    self.order = order
    self.activityVerifierId = activityVerifierId
    self.displays = displays

    preferredDisplay = displays.findDisplayWithFallback() as? ActivityVerifierCredentialClaimDisplay
  }

  // MARK: Public

  public var key: String
  public var order: Int16
  public var value: String
  public var valueType: ValueType
  public var preferredDisplay: ActivityVerifierCredentialClaimDisplay?

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case valueType = "value_type"
    case key
    case order
    case value
    case id
    case activityVerifierId
    case displays
    case preferredDisplay
  }

  var id: UUID
  var activityVerifierId: UUID
  var displays: [ActivityVerifierCredentialClaimDisplay]
}

extension ActivityVerifierCredentialClaim {

  public var imageData: Data? {
    valueType.isImage ? Data(base64URLEncoded: value) : nil
  }
}
