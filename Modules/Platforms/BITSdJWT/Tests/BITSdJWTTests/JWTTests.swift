import BITCore
import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks

// MARK: - JWTTests

final class JWTTests: XCTestCase {

  func testAlgorithmHeader() throws {
    let jwt: JWT = .Mock.sample
    let algorithmHeader = jwt.algorithmHeader
    XCTAssertNotNil(algorithmHeader)
    XCTAssertEqual("ES512", algorithmHeader)
  }

}
