import BITDataStore
import CoreData
import Foundation

extension CredentialDisplayEntity {

  // MARK: Lifecycle

  public convenience init(context moc: NSManagedObjectContext, display: CredentialDisplay) {
    self.init(context: moc)
    setValues(from: display)
  }

  // MARK: Internal

  func setValues(from display: CredentialDisplay) {
    id = display.id
    locale = display.locale
    name = display.name
    logoAltText = display.logoAltText
    logoData = display.logoBase64
    logoUrl = display.logoUrl
    summary = display.summary
    backgroundColor = display.backgroundColor
    textColor = display.textColor
  }

}
