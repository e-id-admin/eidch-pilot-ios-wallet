import Foundation
import JOSESwift

extension JWSHeader {

  init(algorithm: SignatureAlgorithm, kid: String, type: String) {
    self.init(algorithm: algorithm)
    self.kid = kid
    typ = type
  }

}
