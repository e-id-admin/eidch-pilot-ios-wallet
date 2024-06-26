import CoreData
import Foundation

// MARK: - CredentialEntity

public class CredentialEntity: NSManagedObject {
  @NSManaged public var createdAt: Date
  @NSManaged public var id: UUID
  @NSManaged public var status: String
  @NSManaged public var updatedAt: Date?
  @NSManaged public var claims: NSOrderedSet?
  @NSManaged public var issuerDisplays: NSSet?
  @NSManaged public var rawCredentials: NSSet?
  @NSManaged public var displays: NSSet?
  @NSManaged public var activities: NSSet?

}

extension CredentialEntity {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialEntity> {
    let request = NSFetchRequest<CredentialEntity>(entityName: "CredentialEntity")
    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

    return request
  }

  @nonobjc
  public class func fetchRequest(byId id: UUID) -> NSFetchRequest<CredentialEntity> {
    let request = NSFetchRequest<CredentialEntity>(entityName: "CredentialEntity")
    request.predicate = .init(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    return request
  }
}

// MARK: Generated accessors for claims

extension CredentialEntity {

  @objc(insertObject:inClaimsAtIndex:)
  @NSManaged
  public func insertIntoClaims(_ value: CredentialClaimEntity, at idx: Int)

  @objc(removeObjectFromClaimsAtIndex:)
  @NSManaged
  public func removeFromClaims(at idx: Int)

  @objc(insertClaims:atIndexes:)
  @NSManaged
  public func insertIntoClaims(_ values: [CredentialClaimEntity], at indexes: NSIndexSet)

  @objc(removeClaimsAtIndexes:)
  @NSManaged
  public func removeFromClaims(at indexes: NSIndexSet)

  @objc(replaceObjectInClaimsAtIndex:withObject:)
  @NSManaged
  public func replaceClaims(at idx: Int, with value: CredentialClaimEntity)

  @objc(replaceClaimsAtIndexes:withClaims:)
  @NSManaged
  public func replaceClaims(at indexes: NSIndexSet, with values: [CredentialClaimEntity])

  @objc(addClaimsObject:)
  @NSManaged
  public func addToClaims(_ value: CredentialClaimEntity)

  @objc(removeClaimsObject:)
  @NSManaged
  public func removeFromClaims(_ value: CredentialClaimEntity)

  @objc(addClaims:)
  @NSManaged
  public func addToClaims(_ values: NSOrderedSet)

  @objc(removeClaims:)
  @NSManaged
  public func removeFromClaims(_ values: NSOrderedSet)

}

// MARK: Generated accessors for issuer displays

extension CredentialEntity {

  @objc(addIssuerDisplaysObject:)
  @NSManaged
  public func addToIssuerDisplays(_ value: CredentialIssuerDisplayEntity)

  @objc(removeIssuerDisplaysObject:)
  @NSManaged
  public func removeFromIssuerDisplays(_ value: CredentialIssuerDisplayEntity)

  @objc(addIssuerDisplays:)
  @NSManaged
  public func addToIssuerDisplays(_ values: NSSet)

  @objc(removeIssuerDisplays:)
  @NSManaged
  public func removeFromIssuerDisplays(_ values: NSSet)

}

// MARK: Generated accessors for rawCredentials

extension CredentialEntity {

  @objc(addRawCredentialsObject:)
  @NSManaged
  public func addToRawCredentials(_ value: CredentialRawEntity)

  @objc(removeRawCredentialsObject:)
  @NSManaged
  public func removeFromRawCredentials(_ value: CredentialRawEntity)

  @objc(addRawCredentials:)
  @NSManaged
  public func addToRawCredentials(_ values: NSSet)

  @objc(removeRawCredentials:)
  @NSManaged
  public func removeFromRawCredentials(_ values: NSSet)

}

// MARK: Generated accessors for displays

extension CredentialEntity {

  @objc(addDisplaysObject:)
  @NSManaged
  public func addToDisplays(_ value: CredentialDisplayEntity)

  @objc(removeDisplaysObject:)
  @NSManaged
  public func removeFromDisplays(_ value: CredentialDisplayEntity)

  @objc(addDisplays:)
  @NSManaged
  public func addToDisplays(_ values: NSSet)

  @objc(removeDisplays:)
  @NSManaged
  public func removeFromDisplays(_ values: NSSet)

}

// MARK: Generated accessors for activities

extension CredentialEntity {

  @objc(addActivitiesObject:)
  @NSManaged
  public func addToActivities(_ value: ActivityEntity)

  @objc(removeActivitiesObject:)
  @NSManaged
  public func removeFromActivities(_ value: ActivityEntity)

  @objc(addActivities:)
  @NSManaged
  public func addToActivities(_ values: NSSet)

  @objc(removeActivities:)
  @NSManaged
  public func removeFromActivities(_ values: NSSet)

}
