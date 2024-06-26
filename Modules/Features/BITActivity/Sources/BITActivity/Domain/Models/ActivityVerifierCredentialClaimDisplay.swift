import BITCore
import BITCredentialShared
import BITDataStore
import Foundation

public struct ActivityVerifierCredentialClaimDisplay: Codable, DisplayLocalizable {

  public init(_ entity: ActivityVerifierCredentialClaimDisplayEntity) {
    id = entity.id
    name = entity.name
    locale = entity.locale
    activityClaimId = entity.activityVerifierCredentialClaim.id
  }

  public init(id: UUID = UUID(), name: String, locale: String, activityClaimId: UUID? = nil) {
    self.id = id
    self.name = name
    self.locale = locale
    self.activityClaimId = activityClaimId
  }

  public var name: String
  public var locale: UserLocale?

  var id: UUID = .init()
  var activityClaimId: UUID?
}
