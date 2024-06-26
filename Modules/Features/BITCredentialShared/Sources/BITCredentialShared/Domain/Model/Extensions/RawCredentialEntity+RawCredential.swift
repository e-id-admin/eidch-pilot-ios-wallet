import BITDataStore
import CoreData

extension CredentialRawEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, credential: RawCredential) {
    self.init(context: moc)
    setValues(from: credential)
  }

  // MARK: Internal

  func setValues(from credential: RawCredential) {
    privateKeyIdentifier = credential.privateKeyIdentifier
    format = credential.format
    payload = credential.payload
    createdAt = credential.createdAt
    updatedAt = credential.updatedAt
    algorithm = credential.algorithm
  }

}
