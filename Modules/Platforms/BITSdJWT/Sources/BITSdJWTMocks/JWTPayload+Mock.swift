import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension JWTPayload: Mockable {
  struct Mock {
    static let sample: JWTPayload = .decode(fromFile: "jwt-payload", bundle: Bundle.module)
  }
}
