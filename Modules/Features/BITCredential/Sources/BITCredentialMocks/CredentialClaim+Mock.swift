import Foundation
@testable import BITCredential
@testable import BITTestingCore

extension CredentialClaim {

  struct Mock {
    static var array: [CredentialClaim] = [.init(key: "test", value: "1234", credentialId: Credential.Mock.sample.id)]
  }

}
