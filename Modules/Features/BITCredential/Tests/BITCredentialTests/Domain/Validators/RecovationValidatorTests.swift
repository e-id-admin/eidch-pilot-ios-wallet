import BITNetworking
import Foundation
import XCTest
@testable import BITCredential
@testable import BITSdJWT
@testable import BITSdJWTMocks

// MARK: - RevocationValidatorTests

final class RevocationValidatorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    repository = CredentialRepositoryProtocolSpy()
    decoder = SdJWTDecoderProtocolSpy()
  }

  func testSuccessfulValidation() async throws {
    repository.fetchCredentialStatusFromReturnValue = try getJwt()
    decoder.decodeStatusFromAtReturnValue = 0 // 0 being valid status

    let value = try await RevocationValidator(repository: repository).validate(SdJWT.Mock.sample)
    XCTAssertTrue(value)
  }

  func testRevocatedOrSuspendedValidation() async throws {
    repository.fetchCredentialStatusFromReturnValue = try getJwt()
    decoder.decodeStatusFromAtReturnValue = 1 // 1 being invalid status

    let value = try await RevocationValidator(repository: repository, decoder: decoder).validate(.Mock.sample)
    XCTAssertFalse(value)
  }

  // MARK: Private

  // swiftlint: disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private var decoder: SdJWTDecoderProtocolSpy!
  private let dateBuffer: TimeInterval = 15

  // swiftlint: enable all

  private func getJwt() throws -> JWT {
    let data = JWT.Mock.validStatusSampleData
    let raw = try NetworkContainer.shared.decoder().decode(String.self, from: data)
    return try JWT(raw: raw)
  }
}
