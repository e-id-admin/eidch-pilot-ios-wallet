import BITDataStore
import CoreData

extension ActivityVerifierEntity {

  // MARK: Lifecycle

  public convenience init(context managedObjectContext: NSManagedObjectContext, activityVerifier: ActivityVerifier) {
    self.init(context: managedObjectContext)
    setValues(from: activityVerifier)

    let claims = NSSet(array: activityVerifier.credentialClaims.map { ActivityVerifierCredentialClaimEntity(context: managedObjectContext, claim: $0) } )
    addToActivityVerifierCredentialClaims(claims)
  }

  // MARK: Internal

  func setValues(from activityVerifier: ActivityVerifier) {
    id = activityVerifier.id
    name = activityVerifier.name
    logo = activityVerifier.logo
  }

}
