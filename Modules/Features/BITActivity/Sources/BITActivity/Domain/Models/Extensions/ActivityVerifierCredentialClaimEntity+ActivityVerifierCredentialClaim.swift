import BITDataStore
import CoreData

extension ActivityVerifierCredentialClaimEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, claim: ActivityVerifierCredentialClaim) {
    self.init(context: moc)
    setValues(from: claim)

    let displays = NSSet(array: claim.displays.map { ActivityVerifierCredentialClaimDisplayEntity(context: moc, display: $0) })
    addToActivityVerifierCredentialClaimDisplays(displays)
  }

  // MARK: Internal

  func setValues(from claim: ActivityVerifierCredentialClaim) {
    id = claim.id
    key = claim.key
    value = claim.value
    valueType = claim.valueType.rawValue
    order = claim.order
  }
}
