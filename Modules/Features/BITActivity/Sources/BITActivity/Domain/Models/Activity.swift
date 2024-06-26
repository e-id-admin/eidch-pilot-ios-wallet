import BITCredentialShared
import BITDataStore
import Foundation

// MARK: - Activity

public struct Activity: Codable, Identifiable {

  // MARK: Lifecycle

  public init?(_ entity: ActivityEntity) {
    guard let activityType = ActivityType(rawValue: entity.type) else {
      return nil
    }

    id = entity.id
    type = activityType
    createdAt = entity.createdAt
    credential = Credential(entity.credential)
    credentialSnapshotStatus = CredentialStatus(rawValue: entity.credentialSnapshotStatus) ?? .unknown

    if let verifier = entity.verifier {
      self.verifier = ActivityVerifier(verifier)
    }
  }

  public init(_ credential: Credential, activityType: ActivityType, verifier: ActivityVerifier?) {
    type = activityType
    credentialSnapshotStatus = credential.status
    self.credential = credential
    self.verifier = verifier
  }

  // MARK: Public

  public var id: UUID = .init()
  public var type: ActivityType
  public var createdAt: Date = .init()
  public var verifier: ActivityVerifier?
  public var credential: Credential
  public var credentialSnapshotStatus: CredentialStatus
}

// MARK: Equatable

extension Activity: Equatable {

  public static func == (lhs: Activity, rhs: Activity) -> Bool {
    lhs.id == rhs.id &&
      lhs.type == rhs.type &&
      lhs.createdAt == rhs.createdAt &&
      lhs.credential == rhs.credential &&
      lhs.credentialSnapshotStatus == rhs.credentialSnapshotStatus &&
      lhs.verifier == rhs.verifier
  }
}
