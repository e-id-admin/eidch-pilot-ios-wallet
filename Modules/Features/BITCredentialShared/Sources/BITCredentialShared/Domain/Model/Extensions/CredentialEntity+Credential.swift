import BITDataStore
import CoreData

extension CredentialEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, credential: Credential) {
    self.init(context: moc)
    setValues(from: credential)

    let rawCredentialEntities = NSSet(array: credential.rawCredentials.map { CredentialRawEntity(context: moc, credential: $0) })
    addToRawCredentials(rawCredentialEntities)

    let sortedClaims = credential.claims.sorted(by: { $0.order < $1.order })
    let claimEntities = NSOrderedSet(array: sortedClaims.map { CredentialClaimEntity(context: moc, claim: $0) })
    addToClaims(claimEntities)

    let issuerEntities = NSSet(array: credential.issuerDisplays.map { CredentialIssuerDisplayEntity(context: moc, issuer: $0) })
    addToIssuerDisplays(issuerEntities)

    let displays = NSSet(array: credential.displays.map { CredentialDisplayEntity(context: moc, display: $0) })
    addToDisplays(displays)
  }

  // MARK: Public

  public func setValues(from credential: Credential) {
    id = credential.id
    status = credential.status.rawValue
    createdAt = credential.createdAt
    updatedAt = credential.updatedAt
  }

}
