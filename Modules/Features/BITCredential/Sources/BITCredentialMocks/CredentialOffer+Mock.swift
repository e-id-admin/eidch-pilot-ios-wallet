import Foundation
@testable import BITCredential
@testable import BITTestingCore

extension CredentialOffer: Mockable {
  struct Mock {
    static let sample: CredentialOffer = .decode(fromFile: "oid-credential-offer", bundle: Bundle.module)
  }
}
