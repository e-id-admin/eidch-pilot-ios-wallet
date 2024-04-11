import BITLocalAuthentication
import BITSdJWT
import Factory
import Foundation

struct ValidUntilValidator: StatusCheckValidatorProtocol {

  init(dateBuffer: TimeInterval = Container.shared.dateBuffer()) {
    self.dateBuffer = dateBuffer
  }

  let dateBuffer: TimeInterval

  func validate(_ sdJwt: SdJWT) async throws -> Bool {
    guard let validUntil = sdJwt.validUntil else { return false }
    let now = Date().addingTimeInterval(dateBuffer)

    return now <= validUntil
  }
}
