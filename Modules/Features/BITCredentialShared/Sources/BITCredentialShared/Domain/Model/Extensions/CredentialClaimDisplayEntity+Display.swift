import BITCore
import BITDataStore
import CoreData
import Foundation

extension CredentialClaimDisplayEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, display: CredentialClaimDisplay) {
    self.init(context: moc)
    setValues(from: display)
  }

  // MARK: Internal

  func setValues(from display: CredentialClaimDisplay) {
    id = display.id
    locale = display.locale ?? .defaultLocaleIdentifier
    name = display.name
  }

}
