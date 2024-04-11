import BITDataStore
import CoreData

extension CredentialClaimEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, claim: CredentialClaim) {
    self.init(context: moc)
    setValues(from: claim)

    let displays = NSSet(array: claim.displays.map { CredentialClaimDisplayEntity(context: moc, display: $0) })
    addToDisplays(displays)
  }

  // MARK: Internal

  func setValues(from claim: CredentialClaim) {
    id = claim.id
    key = claim.key
    order = claim.order
    value = claim.value
    valueType = claim.valueType
  }

}
