import BITCore
import BITDataStore
import BITSdJWT
import Factory
import Foundation

// MARK: - CredentialError

public enum CredentialError: Error {
  case selectedCredentialNotFound
  case invalidDisplay
}

// MARK: - Credential

public struct Credential: Identifiable, Codable {

  // MARK: Lifecycle

  public init(
    id: UUID = .init(),
    status: CredentialStatus = .valid,
    rawCredentials: [RawCredential] = [],
    claims: [CredentialClaim] = [],
    issuerDisplays: [CredentialIssuerDisplay] = [],
    displays: [CredentialDisplay] = [],
    createdAt: Date = .init(),
    updatedAt: Date? = nil)
  {
    self.id = id
    self.rawCredentials = rawCredentials
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.status = status
    self.claims = claims
    self.issuerDisplays = issuerDisplays
    self.displays = displays

    preferredDisplay = displays.findDisplayWithFallback() as? CredentialDisplay
    preferredIssuerDisplay = issuerDisplays.findDisplayWithFallback() as? CredentialIssuerDisplay
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    try self.init(
      id: container.decode(UUID.self, forKey: .id),
      status: container.decode(CredentialStatus.self, forKey: .status),
      rawCredentials: container.decode([RawCredential].self, forKey: .rawCredentials),
      claims: container.decode([CredentialClaim].self, forKey: .claims),
      issuerDisplays: container.decode([CredentialIssuerDisplay].self, forKey: .issuerDisplays),
      displays: container.decode([CredentialDisplay].self, forKey: .displays),
      createdAt: container.decode(Date.self, forKey: .createdAt),
      updatedAt: container.decodeIfPresent(Date.self, forKey: .updatedAt))
  }

  public init(_ entity: CredentialEntity) {
    self.init(
      id: entity.id,
      status: CredentialStatus(rawValue: entity.status) ?? .unknown,
      rawCredentials: (entity.rawCredentials?.allObjects as? [CredentialRawEntity])?.map { RawCredential($0) } ?? [],
      claims: (entity.claims?.array as? [CredentialClaimEntity])?.map { CredentialClaim($0) } ?? [],
      issuerDisplays: (entity.issuerDisplays?.allObjects as? [CredentialIssuerDisplayEntity])?.map { CredentialIssuerDisplay($0) } ?? [],
      displays: (entity.displays?.allObjects as? [CredentialDisplayEntity])?.map { .init($0) } ?? [],
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt)
  }

  public init(from rawCredential: RawCredential, metadataWrapper: CredentialMetadataWrapper) throws {
    let id = UUID()
    guard let selectedCredential = metadataWrapper.selectedCredential else {
      throw CredentialError.selectedCredentialNotFound
    }

    try self.init(
      id: id,
      status: .unknown,
      rawCredentials: [rawCredential],
      claims: Self.getClaims(from: rawCredential, selectedCredential: selectedCredential, id: id),
      issuerDisplays: metadataWrapper.credentialMetadata.display.map { CredentialIssuerDisplay($0, credentialId: id) },
      displays: selectedCredential.display?.map { .init($0) } ?? [],
      createdAt: .init(),
      updatedAt: nil)
  }

  // MARK: Public

  public var id: UUID = .init()
  public var status: CredentialStatus = .unknown

  public var createdAt: Date = .init()
  public var updatedAt: Date? = nil

  public var rawCredentials: [RawCredential] = []
  public var claims: [CredentialClaim] = []
  public var displays: [CredentialDisplay] = []
  public var issuerDisplays: [CredentialIssuerDisplay] = []

  public var preferredDisplay: CredentialDisplay?
  public var preferredIssuerDisplay: CredentialIssuerDisplay?
}

// MARK: Static

extension Credential {

  private static func getClaims(from rawCredential: RawCredential, selectedCredential: CredentialMetadata.CredentialsSupported, id: UUID) throws -> [CredentialClaim] {
    guard let sdJWT = SdJWT(from: rawCredential.payload) else { throw SdJWTError.notFound }
    var mappedClaims = [CredentialClaim]()
    for sdJWTClaim in sdJWT.claims {
      guard
        let metadataClaim = selectedCredential.credentialDefinition.credentialSubject
          .first(where: { $0.key == sdJWTClaim.key }) else { continue }
      do {
        let claim = try CredentialClaim(metadataClaim, sdJWTClaim: sdJWTClaim, credentialId: id)
        mappedClaims.append(claim)
      } catch {
        continue
      }
    }
    return mappedClaims
  }

}

// MARK: Equatable

extension Credential: Equatable {

  public static func == (lhs: Credential, rhs: Credential) -> Bool {
    lhs.id == rhs.id &&
      lhs.status == rhs.status &&
      lhs.createdAt == rhs.createdAt &&
      lhs.updatedAt == rhs.updatedAt &&
      lhs.rawCredentials.map({ rawCredentialLhs in rhs.rawCredentials.contains(where: { $0 == rawCredentialLhs }) }).allSatisfy({ $0 }) &&
      lhs.issuerDisplays.map({ issuerLhs in rhs.issuerDisplays.contains(where: { $0 == issuerLhs }) }).allSatisfy({ $0 }) &&
      lhs.displays.map({ displayLhs in rhs.displays.contains(where: { $0 == displayLhs }) }).allSatisfy({ $0 }) &&
      lhs.claims.map({ claimLhs in rhs.claims.contains(where: { $0 == claimLhs }) }).allSatisfy({ $0 })
  }
}
