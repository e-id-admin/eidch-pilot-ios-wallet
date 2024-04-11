import BITCore
import Foundation
import OSLog

// MARK: - CredentialMetadataWrapper

/**
 - Description: CredentialMetadataWrapper handles the mapping between the selectedCredential coming from the metadata and the metadata themselves. That selectedCredentialID will allow us to find later on the correct rawCredential payload and map the corresponding claims.
 */

public struct CredentialMetadataWrapper {

  var credentialMetadata: CredentialMetadata
  var selectedCredential: CredentialMetadata.CredentialsSupported?
  var privateKeyIdentifier: UUID = .init()

  public init(selectedCredentialSupportedId: String, credentialMetadata: CredentialMetadata, privateKeyIdentifier: UUID = .init()) {
    self.credentialMetadata = credentialMetadata
    if let selectedCredential = credentialMetadata.credentialsSupported.first(where: { $0.key == selectedCredentialSupportedId })?.value {
      self.selectedCredential = selectedCredential
    }
    self.privateKeyIdentifier = privateKeyIdentifier
  }

}

// MARK: - CredentialMetadata

public struct CredentialMetadata: Codable, Equatable {

  // MARK: Lifecycle

  init(credentialIssuer: String, credentialEndpoint: String, credentialsSupported: [String: CredentialsSupported], display: [CredentialMetadataDisplay]) {
    self.credentialIssuer = credentialIssuer
    self.credentialEndpoint = credentialEndpoint
    self.credentialsSupported = credentialsSupported
    self.display = display
    preferredDisplay = display.findDisplayWithFallback() as? CredentialMetadataDisplay
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let credentialIssuer = try container.decode(String.self, forKey: .credentialIssuer)
    let credentialEndpoint = try container.decode(String.self, forKey: .credentialEndpoint)
    let credentialsSupported = try container.decode([String: CredentialsSupported].self, forKey: .credentialsSupported)
    let display = try container.decode([CredentialMetadataDisplay].self, forKey: .display)

    self.init(credentialIssuer: credentialIssuer, credentialEndpoint: credentialEndpoint, credentialsSupported: credentialsSupported, display: display)
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case credentialIssuer = "credential_issuer"
    case credentialEndpoint = "credential_endpoint"
    case credentialsSupported = "credentials_supported"
    case display
    case preferredDisplay
  }

  let credentialIssuer: String
  let credentialEndpoint: String
  let credentialsSupported: [String: CredentialsSupported]
  let display: [CredentialMetadataDisplay]
  let preferredDisplay: CredentialMetadataDisplay?

}

// MARK: CredentialMetadata.CredentialsSupported

extension CredentialMetadata {
  public struct CredentialsSupported: Codable, Equatable {

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      format = try container.decode(String.self, forKey: .format)
      cryptographicSuitesSupported = try container.decode([String].self, forKey: .cryptographicSuitesSupported)
      cryptographicBindingMethodsSupported = try container.decodeIfPresent([String].self, forKey: .cryptographicBindingMethodsSupported)
      proofTypesSupported = try container.decode([String].self, forKey: .proofTypesSupported)
      display = try container.decodeIfPresent([CredentialSupportedDisplay].self, forKey: .display)
      orderClaims = try container.decodeIfPresent([String].self, forKey: .orderClaims)

      let dtoCredentialDefinition = try container.decode(CredentialDefinition.self, forKey: .credentialDefinition)
      credentialDefinition = .init(fromSource: dtoCredentialDefinition, orderClaims: orderClaims)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
      case format
      case cryptographicSuitesSupported = "cryptographic_suites_supported"
      case cryptographicBindingMethodsSupported = "cryptographic_binding_methods_supported"
      case proofTypesSupported = "proof_types_supported"
      case credentialDefinition = "credential_definition"
      case display
      case orderClaims = "order"
    }

    let format: String
    let cryptographicSuitesSupported: [String]
    let cryptographicBindingMethodsSupported: [String]?
    let proofTypesSupported: [String]
    let credentialDefinition: CredentialDefinition
    let display: [CredentialSupportedDisplay]?
    let orderClaims: [String]?

  }
}

// MARK: CredentialMetadata.CredentialSupportedDisplay

extension CredentialMetadata {

  // MARK: Public

  public struct CredentialSupportedDisplay: Codable, Equatable {

    // MARK: Lifecycle

    init(
      name: String,
      locale: String? = nil,
      logo: CredentialSupportedDisplayLogo? = nil,
      summary: String? = nil,
      backgroundColor: String? = nil,
      textColor: String? = nil)
    {
      self.name = name
      self.locale = locale
      self.logo = logo
      self.summary = summary
      self.backgroundColor = backgroundColor
      self.textColor = textColor
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
      case name, locale, logo
      case summary = "description"
      case backgroundColor = "background_color"
      case textColor = "text_color"
    }

    let name: String
    let locale: String?
    let logo: CredentialSupportedDisplayLogo?
    let summary: String?
    let backgroundColor: String?
    let textColor: String?

  }

  // MARK: Internal

  struct CredentialSupportedDisplayLogo: Codable, Equatable {
    let url: URL?
    let altText: String?
    let data: String?

    enum CodingKeys: String, CodingKey {
      case url, data
      case altText = "alt_text"
    }
  }
}

// MARK: CredentialMetadata.CredentialDefinition

extension CredentialMetadata {
  struct CredentialDefinition: Codable, Equatable {

    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      type = try container.decode([String].self, forKey: .type)
      let decodedClaims = try container.decode(DecodedClaimArray.self, forKey: .credentialSubject)
      credentialSubject = decodedClaims.claims
    }

    init(fromSource source: CredentialDefinition, orderClaims: [String]?) {
      var claims: [Claim] = []
      for dtoCredentialSubject in source.credentialSubject {
        let index = orderClaims?.firstIndex(where: { $0 == dtoCredentialSubject.key }) ?? 0
        claims.append(.init(from: dtoCredentialSubject, order: index))
      }
      self.init(type: source.type, credentialSubject: claims)
    }

    private init(type: [String], credentialSubject: [Claim]) {
      self.type = type
      self.credentialSubject = credentialSubject
    }

    // MARK: Internal

    let type: [String]
    let credentialSubject: [Claim]
  }
}

// MARK: CredentialMetadata.DecodedClaimArray

extension CredentialMetadata {
  struct DecodedClaimArray: Codable {

    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
      var tempArray = [Claim]()

      for key in container.allKeys {
        guard let key = DynamicCodingKeys(stringValue: key.stringValue) else { continue }
        let decodedObject = try container.decode(Claim.self, forKey: key)
        tempArray.append(decodedObject)
      }

      claims = tempArray
    }

    // MARK: Internal

    var claims: [Claim]

    // MARK: Private

    private struct DynamicCodingKeys: CodingKey {
      var intValue: Int?

      init?(intValue: Int) {
        nil
      }

      var stringValue: String
      init?(stringValue: String) {
        self.stringValue = stringValue
      }
    }
  }
}

// MARK: CredentialMetadata.Claim

extension CredentialMetadata {
  public struct Claim: Codable, Equatable {

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      mandatory = try container.decodeIfPresent(Bool.self, forKey: .mandatory)
      valueType = try container.decodeIfPresent(ValueType.self, forKey: .valueType)
      display = try container.decodeIfPresent([ClaimDisplay].self, forKey: .display)
      order = try container.decodeIfPresent(Int.self, forKey: .order) ?? 0
      guard let key = container.codingPath.last?.stringValue else {
        throw NSError(domain: "No key found", code: 1)
      }
      self.key = key
    }

    init(from claim: Claim, order: Int) {
      key = claim.key
      mandatory = claim.mandatory
      valueType = claim.valueType
      display = claim.display
      self.order = order
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
      case mandatory
      case valueType = "value_type"
      case display
      case order
    }

    let mandatory: Bool?
    let valueType: ValueType?
    let display: [ClaimDisplay]?
    let key: String
    let order: Int

  }
}

// MARK: CredentialMetadata.ClaimDisplay

extension CredentialMetadata {
  public struct ClaimDisplay: Codable, Equatable {
    let locale: String
    let name: String
  }
}

// MARK: CredentialMetadata.CredentialMetadataDisplay

extension CredentialMetadata {

  // MARK: Public

  public struct CredentialMetadataDisplay: Codable, Equatable, DisplayLocalizable {
    let name: String
    let locale: String?
    let logo: CredentialMetadataDisplayLogo?
  }

  // MARK: Internal

  struct CredentialMetadataDisplayLogo: Codable, Equatable {
    let data: String?
  }
}
