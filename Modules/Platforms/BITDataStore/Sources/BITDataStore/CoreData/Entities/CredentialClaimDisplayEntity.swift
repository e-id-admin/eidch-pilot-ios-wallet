import CoreData
import Foundation

// MARK: - CredentialClaimDisplayEntity

public class CredentialClaimDisplayEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var locale: String
  @NSManaged public var name: String
  @NSManaged public var claim: CredentialClaimEntity?

}

extension CredentialClaimDisplayEntity {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialClaimDisplayEntity> {
    NSFetchRequest<CredentialClaimDisplayEntity>(entityName: "CredentialClaimDisplayEntity")
  }

}
