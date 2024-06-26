import BITDataStore
import CoreData

extension CredentialIssuerDisplayEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, issuer: CredentialIssuerDisplay) {
    self.init(context: moc)
    setValues(from: issuer)
  }

  // MARK: Internal

  func setValues(from issuer: CredentialIssuerDisplay) {
    id = issuer.id
    locale = issuer.locale
    name = issuer.name
    image = issuer.image
  }

}
