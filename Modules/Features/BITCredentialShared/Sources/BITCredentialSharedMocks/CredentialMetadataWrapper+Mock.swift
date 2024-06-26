import Foundation

@testable import BITCredentialShared
@testable import BITTestingCore

extension CredentialMetadataWrapper {
  struct Mock {
    static var sample = CredentialMetadataWrapper(selectedCredentialSupportedId: "sd_elfa_jwt", credentialMetadata: .Mock.sample, privateKeyIdentifier: .init())
    static var sampleUnknownAlgorithm = CredentialMetadataWrapper(selectedCredentialSupportedId: "sd_elfa_jwt", credentialMetadata: .Mock.sampleUnknownAlgorithm, privateKeyIdentifier: .init())
  }
}
