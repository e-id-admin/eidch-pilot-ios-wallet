import CoreData
import Foundation

public class CredentialIssuerDisplayEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var locale: String?
  @NSManaged public var name: String
  @NSManaged public var credential: CredentialEntity
  @NSManaged public var image: Data?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialIssuerDisplayEntity> {
    NSFetchRequest<CredentialIssuerDisplayEntity>(entityName: "CredentialIssuerDisplayEntity")
  }

}
