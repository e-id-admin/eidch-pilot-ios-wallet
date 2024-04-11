import CoreData
import Foundation

// MARK: - CredentialRawEntity

public class CredentialRawEntity: NSManagedObject {

  @NSManaged public var createdAt: Date
  @NSManaged public var format: String
  @NSManaged public var payload: Data
  @NSManaged public var privateKeyIdentifier: UUID
  @NSManaged public var algorithm: String
  @NSManaged public var updatedAt: Date?
  @NSManaged public var credential: CredentialEntity?

}

extension CredentialRawEntity {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CredentialRawEntity> {
    NSFetchRequest<CredentialRawEntity>(entityName: "CredentialRawEntity")
  }

  @nonobjc
  public class func fetchRequest(byPrivateKeyIdentifier key: UUID) -> NSFetchRequest<CredentialRawEntity> {
    let request = NSFetchRequest<CredentialRawEntity>(entityName: "CredentialRawEntity")
    request.predicate = .init(format: "privateKeyIdentifier == %@", key as CVarArg)
    request.fetchLimit = 1
    return request
  }

}
