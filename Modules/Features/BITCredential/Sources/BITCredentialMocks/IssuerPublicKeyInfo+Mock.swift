import Foundation
@testable import BITCredential
@testable import BITTestingCore

extension IssuerPublicKeyInfo: Mockable {
  struct Mock {
    static let sample: IssuerPublicKeyInfo = .decode(fromFile: "jwks", bundle: Bundle.module)
    static let sampleData: Data = IssuerPublicKeyInfo.getData(fromFile: "jwks", bundle: Bundle.module) ?? Data()
    static let samplesMultiple: IssuerPublicKeyInfo = .decode(fromFile: "jwks-multiple", bundle: Bundle.module)
  }
}
