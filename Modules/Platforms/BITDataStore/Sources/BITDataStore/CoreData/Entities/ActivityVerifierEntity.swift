import CoreData
import Foundation

// MARK: - ActivityVerifierEntity

public class ActivityVerifierEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var logo: Data?
  @NSManaged public var activity: ActivityEntity
  @NSManaged public var activityVerifierCredentialClaims: NSSet

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ActivityVerifierEntity> {
    NSFetchRequest<ActivityVerifierEntity>(entityName: "ActivityVerifierEntity")
  }
}

extension ActivityVerifierEntity {

  @objc(addActivityVerifierCredentialClaimsObject:)
  @NSManaged
  public func addToActivityVerifierCredentialClaims(_ value: ActivityVerifierCredentialClaimEntity)

  @objc(removeActivityVerifierCredentialClaimsObject:)
  @NSManaged
  public func removeFromActivityVerifierCredentialClaims(_ value: ActivityVerifierCredentialClaimEntity)

  @objc(addActivityVerifierCredentialClaims:)
  @NSManaged
  public func addToActivityVerifierCredentialClaims(_ values: NSSet)

  @objc(removeActivityVerifierCredentialClaims:)
  @NSManaged
  public func removeFromActivityVerifierCredentialClaims(_ values: NSSet)

}
