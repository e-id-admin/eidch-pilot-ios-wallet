import BITSdJWT
import Foundation
import XCTest
@testable import BITCredential
@testable import BITSdJWTMocks

final class ValidUntilValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    repository = CredentialRepositoryProtocolSpy()
  }

  func testSuccessfulValidation() async throws {
    var sdJwt = SdJWT.Mock.sample
    let validUntil: Date = .now + 7 * 24 * 60 * 60 // 7 days in the future
    sdJwt.validUntil = validUntil

    let value = try await ValidUntilValidator().validate(sdJwt)
    XCTAssertTrue(value)
  }

  func testExpiredValidation() async throws {
    var sdJwt = SdJWT.Mock.sample
    let validUntil: Date = .now - 60
    sdJwt.validUntil = validUntil

    let value = try await ValidUntilValidator().validate(sdJwt)
    XCTAssertFalse(value)
  }

  // MARK: Private

  // swiftlint: disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private let dateBuffer: TimeInterval = 15
  // swiftlint: enable all

}
