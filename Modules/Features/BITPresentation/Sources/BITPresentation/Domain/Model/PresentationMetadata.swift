import BITCore
import BITCredentialShared
import BITSdJWT
import Foundation

// MARK: - PresentationMetadata

public struct PresentationMetadata: Codable {

  // MARK: Lifecycle

  public init(attributes: [Field], verifier: Verifier?) {
    self.attributes = attributes
    self.verifier = verifier
  }

  public init(_ compatibleCredential: CompatibleCredential, verifier: Verifier?) throws {
    let requiredFields = compatibleCredential.fields
    var fields = [Field]()

    if requiredFields.isEmpty {
      throw PresentationMetadataError.noRequiredFields
    }

    for claim in compatibleCredential.credential.claims {
      if requiredFields.contains(where: { $0.rawValue == claim.value }) {
        let displayName = claim.preferredDisplay?.name ?? claim.key

        guard let valueType = ValueType(rawValue: claim.valueType) else {
          throw PresentationMetadataError.invalidValueType
        }

        fields.append(Field(key: claim.key, value: claim.value, type: valueType, displayName: displayName, order: claim.order, displays: claim.displays))
      }
    }

    attributes = fields
    self.verifier = verifier
  }

  // MARK: Internal

  enum PresentationMetadataError: Error {
    case noRequiredFields
    case invalidValueType
  }

  var attributes: [Field] = []
  var verifier: Verifier?
}

// MARK: Equatable

extension PresentationMetadata: Equatable {
  public static func == (lhs: PresentationMetadata, rhs: PresentationMetadata) -> Bool {
    lhs.verifier == rhs.verifier &&
      lhs.attributes.map({ attr in rhs.attributes.contains(where: { $0 == attr }) }).allSatisfy({ $0 })
  }
}

// MARK: PresentationMetadata.Field

extension PresentationMetadata {

  public struct Field: Codable, Hashable, Identifiable {

    // MARK: Lifecycle

    public init(key: String, value: String, type: ValueType, displayName: String, order: Int16, displays: [CredentialClaimDisplay]) {
      self.key = key
      self.value = value
      self.type = type
      self.displayName = displayName
      self.order = order
      self.displays = displays
    }

    // MARK: Public

    public var id: UUID { .init() }

    // MARK: Internal

    var key: String
    var value: String
    var type: ValueType
    var displayName: String
    var order: Int16
    var displays: [CredentialClaimDisplay]

    var imageData: Data? {
      type.isImage ? Data(base64URLEncoded: value) : nil
    }
  }

  // MARK: Internal

}
