import BITCore
import XCTest
@testable import BITCredential
@testable import BITCredentialMocks

final class CredentialMetadataTests: XCTestCase {

  func testLoadTergumMetadata() async throws {
    let credentialMetadata: CredentialMetadata = .Mock.sample

    XCTAssertFalse(credentialMetadata.credentialsSupported.isEmpty)
    XCTAssertFalse(credentialMetadata.display.isEmpty)

    let credentialSupported = credentialMetadata.credentialsSupported.first(where: { $0.key == "sd_elfa_jwt" })?.value
    guard let credentialSupported else { return XCTFail("credentialSupported is nil") }

    XCTAssertNotNil(credentialSupported.cryptographicBindingMethodsSupported)
    XCTAssertNotNil(credentialSupported.display)
    XCTAssertNotNil(credentialSupported.orderClaims)
    XCTAssertFalse(credentialSupported.cryptographicSuitesSupported.isEmpty)
    XCTAssertFalse(credentialSupported.proofTypesSupported.isEmpty)
    // swiftlint:disable force_unwrapping
    XCTAssertFalse(credentialSupported.cryptographicBindingMethodsSupported!.isEmpty)
    XCTAssertFalse(credentialSupported.display!.isEmpty)
    XCTAssertFalse(credentialSupported.orderClaims!.isEmpty)
    // swiftlint:enable force_unwrapping

    XCTAssertFalse(credentialSupported.credentialDefinition.credentialSubject.isEmpty)
    XCTAssertEqual(credentialSupported.credentialDefinition.credentialSubject.count, credentialSupported.orderClaims?.count)

    for credentialSubject in credentialSupported.credentialDefinition.credentialSubject {
      let order = credentialSupported.orderClaims?.firstIndex(where: { $0 == credentialSubject.key })
      XCTAssertEqual(credentialSubject.order, order)
    }
  }

}
