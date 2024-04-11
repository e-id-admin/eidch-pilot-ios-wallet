import CoreData
import Foundation

public class CredentialDisplayEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var locale: String?
  @NSManaged public var logoAltText: String?
  @NSManaged public var logoData: Data?
  @NSManaged public var logoUrl: URL?
  @NSManaged public var summary: String?
  @NSManaged public var backgroundColor: String?
  @NSManaged public var textColor: String?
  @NSManaged public var credential: CredentialEntity?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialDisplayEntity> {
    NSFetchRequest<CredentialDisplayEntity>(entityName: "CredentialDisplayEntity")
  }

}
