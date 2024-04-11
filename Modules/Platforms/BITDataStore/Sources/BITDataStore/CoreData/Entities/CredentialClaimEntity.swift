import CoreData
import Foundation

// MARK: - CredentialClaimEntity

public class CredentialClaimEntity: NSManagedObject {
  @NSManaged public var id: UUID
  @NSManaged public var key: String
  @NSManaged public var order: Int16
  @NSManaged public var value: String
  @NSManaged public var valueType: String
  @NSManaged public var credential: CredentialEntity?
  @NSManaged public var displays: NSSet?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialClaimEntity> {
    NSFetchRequest<CredentialClaimEntity>(entityName: "CredentialClaimEntity")
  }

}

extension CredentialClaimEntity {

  @objc(addDisplaysObject:)
  @NSManaged
  public func addToDisplays(_ value: CredentialClaimDisplayEntity)

  @objc(removeDisplaysObject:)
  @NSManaged
  public func removeFromDisplays(_ value: CredentialClaimDisplayEntity)

  @objc(addDisplays:)
  @NSManaged
  public func addToDisplays(_ values: NSSet)

  @objc(removeDisplays:)
  @NSManaged
  public func removeFromDisplays(_ values: NSSet)

}
