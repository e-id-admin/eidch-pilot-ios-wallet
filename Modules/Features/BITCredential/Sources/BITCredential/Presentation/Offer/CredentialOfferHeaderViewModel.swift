import BITCredentialShared
import Foundation

public struct CredentialOfferHeaderViewModel {
  var name: String
  var imageData: Data?

  public init(_ issuer: CredentialIssuerDisplay) {
    name = issuer.name
    imageData = issuer.image
  }
}
