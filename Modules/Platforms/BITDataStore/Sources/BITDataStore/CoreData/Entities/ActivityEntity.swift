import CoreData
import Foundation

// MARK: - ActivityEntity

public class ActivityEntity: NSManagedObject {

  @NSManaged public var id: UUID
  @NSManaged public var type: String
  @NSManaged public var createdAt: Date
  @NSManaged public var credentialSnapshotStatus: String
  @NSManaged public var credential: CredentialEntity
  @NSManaged public var verifier: ActivityVerifierEntity?
}

extension ActivityEntity {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ActivityEntity> {
    NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
  }

  @nonobjc
  public class func fetchRequest(byId id: UUID) -> NSFetchRequest<ActivityEntity> {
    let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    request.predicate = .init(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    return request
  }

  @nonobjc
  public class func fetchRequest(byCredentialId id: UUID, count: Int? = nil) -> NSFetchRequest<ActivityEntity> {
    let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    request.predicate = .init(format: "credential.id == %@", id as CVarArg)
    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    request.fetchLimit = count ?? 0
    return request
  }

  @nonobjc
  public class func fetchLastRequest() -> NSFetchRequest<ActivityEntity> {
    let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    request.fetchLimit = 1
    return request
  }
}
