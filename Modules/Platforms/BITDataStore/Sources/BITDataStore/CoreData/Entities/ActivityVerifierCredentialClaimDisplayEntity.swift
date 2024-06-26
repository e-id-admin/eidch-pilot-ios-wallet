import CoreData
import Foundation

// MARK: - ActivityVerifierCredentialClaimDisplayEntity

public class ActivityVerifierCredentialClaimDisplayEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var locale: String?
  @NSManaged public var name: String
  @NSManaged public var activityVerifierCredentialClaim: ActivityVerifierCredentialClaimEntity
}

extension ActivityVerifierCredentialClaimDisplayEntity {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ActivityVerifierCredentialClaimDisplayEntity> {
    NSFetchRequest<ActivityVerifierCredentialClaimDisplayEntity>(entityName: "ActivityVerifierCredentialClaimDisplayEntity")
  }
}
