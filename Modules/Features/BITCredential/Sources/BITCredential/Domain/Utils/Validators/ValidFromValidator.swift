import BITSdJWT
import Factory
import Foundation

struct ValidFromValidator: StatusCheckValidatorProtocol {

  init(dateBuffer: TimeInterval = Container.shared.dateBuffer()) {
    self.dateBuffer = dateBuffer
  }

  let dateBuffer: TimeInterval

  func validate(_ sdJwt: SdJWT) async throws -> Bool {
    guard let validFrom = sdJwt.validFrom else { return false }
    let now = Date().addingTimeInterval(dateBuffer)
    return now >= validFrom
  }
}
