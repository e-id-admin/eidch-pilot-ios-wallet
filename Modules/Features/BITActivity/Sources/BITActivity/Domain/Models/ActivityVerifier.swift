import BITDataStore
import Foundation

// MARK: - ActivityVerifier

public struct ActivityVerifier: Codable {

  // MARK: Lifecycle

  public init(_ entity: ActivityVerifierEntity) {
    id = entity.id
    name = entity.name
    logo = entity.logo
    credentialClaims = (entity.activityVerifierCredentialClaims.allObjects as? [ActivityVerifierCredentialClaimEntity])?.compactMap({ ActivityVerifierCredentialClaim($0) }) ?? []
  }

  public init(id: UUID = .init(), name: String, credentialClaims: [ActivityVerifierCredentialClaim] = [], logo: Data? = nil) {
    self.id = id
    self.name = name
    self.logo = logo
    self.credentialClaims = credentialClaims
  }

  // MARK: Public

  public var name: String
  public var logo: Data?
  public var credentialClaims: [ActivityVerifierCredentialClaim]

  // MARK: Internal

  var id: UUID
}

// MARK: Equatable

extension ActivityVerifier: Equatable {

  public static func == (lhs: ActivityVerifier, rhs: ActivityVerifier) -> Bool {
    lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.logo == rhs.logo
  }
}
