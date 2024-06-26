import CoreData
import Foundation

// MARK: - ActivityVerifierCredentialClaimEntity

public class ActivityVerifierCredentialClaimEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var key: String
  @NSManaged public var order: Int16
  @NSManaged public var value: String
  @NSManaged public var valueType: String
  @NSManaged public var activityVerifier: ActivityVerifierEntity
  @NSManaged public var activityVerifierCredentialClaimDisplays: NSSet
}

extension ActivityVerifierCredentialClaimEntity {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ActivityVerifierCredentialClaimEntity> {
    NSFetchRequest<ActivityVerifierCredentialClaimEntity>(entityName: "ActivityVerifierCredentialClaimEntity")
  }

}

// MARK: Generated accessors for activityVerifierCredentialClaimDisplays

extension ActivityVerifierCredentialClaimEntity {

  @objc(addActivityVerifierCredentialClaimDisplaysObject:)
  @NSManaged
  public func addToActivityVerifierCredentialClaimDisplays(_ value: ActivityVerifierCredentialClaimDisplayEntity)

  @objc(removeActivityVerifierCredentialClaimDisplaysObject:)
  @NSManaged
  public func removeFromActivityVerifierCredentialClaimDisplays(_ value: ActivityVerifierCredentialClaimDisplayEntity)

  @objc(addActivityVerifierCredentialClaimDisplays:)
  @NSManaged
  public func addToActivityVerifierCredentialClaimDisplays(_ values: NSSet)

  @objc(removeActivityVerifierCredentialClaimDisplays:)
  @NSManaged
  public func removeFromActivityVerifierCredentialClaimDisplays(_ values: NSSet)

}
