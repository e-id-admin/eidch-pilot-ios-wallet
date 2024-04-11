import Foundation
@testable import BITCredential
@testable import BITTestingCore

// MARK: OpenIdConfiguration.Mock

extension OpenIdConfiguration: Mockable {
  struct Mock {
    static let sample: OpenIdConfiguration = .decode(fromFile: "openid-configuration", bundle: Bundle.module)
    static let sampleData: Data = OpenIdConfiguration.getData(fromFile: "openid-configuration", bundle: Bundle.module) ?? Data()
  }
}
