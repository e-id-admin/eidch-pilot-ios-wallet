import Foundation

@testable import BITCredentialShared
@testable import BITTestingCore

extension CredentialMetadata: Mockable {
  struct Mock {
    static let sample: CredentialMetadata = .decode(fromFile: "tergum-credential-metadata", bundle: Bundle.module)
    static let sampleUnknownAlgorithm: CredentialMetadata = .decode(fromFile: "tergum-credential-metadata-unknown-algo", bundle: Bundle.module)
    static let sampleData: Data = CredentialMetadata.getData(fromFile: "tergum-credential-metadata", bundle: Bundle.module) ?? Data()
  }
}
