import BITSdJWT
import Foundation
import XCTest
@testable import BITCredential
@testable import BITSdJWTMocks

final class ValidFromValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    repository = CredentialRepositoryProtocolSpy()
  }

  func testSuccessfulValidation() async throws {
    var sdJwt = SdJWT.Mock.sample
    let validFrom: Date = .now - 60
    sdJwt.validFrom = validFrom

    let value = try await ValidFromValidator().validate(sdJwt)
    XCTAssertTrue(value) }

  func testExpiredValidation() async throws {
    var sdJwt = SdJWT.Mock.sample
    let validFrom: Date = .now + 7 * 24 * 60 * 60 // 7 days in the future
    sdJwt.validFrom = validFrom

    let value = try await ValidFromValidator().validate(sdJwt)
    XCTAssertFalse(value)
  }

  // MARK: Private

  // swiftlint: disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private let dateBuffer: TimeInterval = 15
  // swiftlint: enable all

}
