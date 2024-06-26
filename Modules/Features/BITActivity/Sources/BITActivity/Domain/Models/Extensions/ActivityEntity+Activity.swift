import BITDataStore
import CoreData

extension ActivityEntity {

  // MARK: Lifecycle

  public convenience init(context managedObjectContext: NSManagedObjectContext, activity: Activity) {
    self.init(context: managedObjectContext)
    setValues(from: activity, and: managedObjectContext)
  }

  // MARK: Internal

  func setValues(from activity: Activity, and context: NSManagedObjectContext) {
    id = activity.id
    type = activity.type.rawValue
    credentialSnapshotStatus = activity.credentialSnapshotStatus.rawValue
    createdAt = activity.createdAt

    if let activityVerifier = activity.verifier {
      verifier = ActivityVerifierEntity(context: context, activityVerifier: activityVerifier)
    }
  }

}
