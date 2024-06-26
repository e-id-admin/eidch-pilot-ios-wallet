import BITCore
import BITDataStore
import Foundation

// MARK: - CredentialDisplay

public struct CredentialDisplay: Codable, Identifiable, DisplayLocalizable {

  // MARK: Lifecycle

  init(
    id: UUID = .init(),
    name: String,
    backgroundColor: String? = nil,
    locale: UserLocale,
    logoAltText: String? = nil,
    logoBase64: Data? = nil,
    logoUrl: URL? = nil,
    summary: String? = nil,
    textColor: String? = nil,
    credentialId: UUID? = nil)
  {
    self.id = id
    self.name = name
    self.backgroundColor = backgroundColor
    self.locale = locale
    self.logoAltText = logoAltText
    self.logoBase64 = logoBase64
    self.logoUrl = logoUrl
    self.summary = summary
    self.textColor = textColor
    self.credentialId = credentialId
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
    locale = try container.decodeIfPresent(String.self, forKey: .locale) ?? UserLocale.defaultLocaleIdentifier
    logoAltText = try container.decodeIfPresent(String.self, forKey: .logoAltText)
    logoBase64 = try container.decodeIfPresent(Data.self, forKey: .logoBase64)
    logoUrl = try container.decodeIfPresent(URL.self, forKey: .logoUrl)
    summary = try container.decodeIfPresent(String.self, forKey: .summary)
    textColor = try container.decodeIfPresent(String.self, forKey: .textColor)
    credentialId = try container.decodeIfPresent(UUID.self, forKey: .credentialId)
  }

  init(_ entity: CredentialDisplayEntity) {
    self.init(
      id: entity.id,
      name: entity.name,
      backgroundColor: entity.backgroundColor,
      locale: entity.locale ?? UserLocale.defaultLocaleIdentifier,
      logoAltText: entity.logoAltText,
      logoBase64: entity.logoData ?? .init(),
      logoUrl: entity.logoUrl,
      summary: entity.summary,
      textColor: entity.textColor,
      credentialId: entity.credential?.id)
  }

  init(_ credentialSupported: CredentialMetadata.CredentialSupportedDisplay) {
    self.init(
      name: credentialSupported.name,
      backgroundColor: credentialSupported.backgroundColor,
      locale: credentialSupported.locale ?? UserLocale.defaultLocaleIdentifier,
      logoAltText: credentialSupported.logo?.altText,
      logoBase64: credentialSupported.logo?.data.flatMap { Data(base64URLEncoded: $0) },
      logoUrl: credentialSupported.logo?.url,
      summary: credentialSupported.summary,
      textColor: credentialSupported.textColor)
  }

  // MARK: Public

  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case backgroundColor = "background_color"
    case locale
    case logoAltText = "logo_alt_text"
    case logoBase64 = "logo_data"
    case logoUrl = "logo_url"
    case summary
    case textColor = "text_color"
    case credentialId = "credential_id"
  }

  public var id: UUID
  public var name: String
  public var backgroundColor: String?
  public var locale: UserLocale?
  public var logoAltText: String?
  public var logoBase64: Data?
  public var logoUrl: URL?
  public var summary: String?
  public var textColor: String?
  public var credentialId: UUID?

}

// MARK: Equatable

extension CredentialDisplay: Equatable {

  public static func == (lhs: CredentialDisplay, rhs: CredentialDisplay) -> Bool {
    lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.backgroundColor == rhs.backgroundColor &&
      lhs.locale == rhs.locale &&
      lhs.logoAltText == rhs.logoAltText &&
      lhs.logoBase64 == rhs.logoBase64 &&
      lhs.logoUrl == rhs.logoUrl &&
      lhs.summary == rhs.summary &&
      lhs.textColor == rhs.textColor &&
      lhs.credentialId == rhs.credentialId
  }

}
