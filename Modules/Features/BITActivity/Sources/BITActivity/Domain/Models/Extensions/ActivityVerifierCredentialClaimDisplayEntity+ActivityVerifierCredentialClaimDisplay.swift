import BITDataStore
import CoreData

extension ActivityVerifierCredentialClaimDisplayEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, display: ActivityVerifierCredentialClaimDisplay) {
    self.init(context: moc)
    setValues(from: display)
  }

  // MARK: Internal

  func setValues(from claim: ActivityVerifierCredentialClaimDisplay) {
    id = claim.id
    name = claim.name
    locale = claim.locale
  }
}
