import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SdJWTTest: XCTestCase {

  func testInit_fromRawCredential() throws {
    let mockSdJWTData = SdJWT.Mock.sampleData
    let decodedSdJWT = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)
    guard let sdJWT = SdJWT(from: decodedSdJWT.raw) else {
      XCTFail("init from rawCredential return nil")
      return
    }
    XCTAssertEqual(decodedSdJWT, sdJWT)
  }

  func testInit_fromJWT() throws {
    let mockSdJWTData = SdJWT.Mock.sampleData
    let decodedSdJWT = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    let parts = decodedSdJWT.raw.split(separator: SdJWT.disclosuresSeparator)
    let disclosures = parts[1..<parts.count]
    let rawDisclosures = disclosures.joined(separator: String(SdJWT.disclosuresSeparator))

    guard let sdJWT = SdJWT(from: decodedSdJWT.jwt, rawDisclosures: rawDisclosures) else {
      XCTFail("init from JWT return nil")
      return
    }
    XCTAssertEqual(decodedSdJWT, sdJWT)
  }

  func testDecodeSample() throws {
    let mockSdJWTData = SdJWT.Mock.sampleData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)
    XCTAssertFalse(credential.raw.isEmpty)
    XCTAssertFalse(credential.digests.isEmpty)
    XCTAssertEqual(17, credential.claims.count)
    XCTAssertEqual(credential.digests.count, credential.digests.count)
    XCTAssertNotNil(credential.verifiableCredential)
    XCTAssertNotNil(credential.jwtIssuedAt)
    XCTAssertNotNil(credential.jwtExpiredAt)
    XCTAssertNotNil(credential.jwtActivatedAt)
    XCTAssertNotNil(credential.verifiableCredential?.validUntil)
    XCTAssertNotNil(credential.verifiableCredential?.validFrom)

    // swiftlint:disable all
    XCTAssertTrue(credential.jwtIssuedAt! < credential.jwtActivatedAt!)
    XCTAssertTrue(credential.jwtActivatedAt! < credential.jwtExpiredAt!)
    XCTAssertTrue(Date() < credential.jwtExpiredAt!)

    XCTAssertTrue(credential.jwtActivatedAt! < credential.jwtExpiredAt!)
    XCTAssertTrue(Date() < credential.jwtExpiredAt!)
    // swiftlint:enable all
  }

  func testDecodeId() throws {
    let mockSdJWTData = SdJWT.Mock.sampleIdData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)
    XCTAssertFalse(credential.raw.isEmpty)
    XCTAssertFalse(credential.digests.isEmpty)
    XCTAssertEqual(3, credential.claims.count)
    XCTAssertEqual(credential.digests.count, credential.digests.count)
  }

  func testDecodeDiploma() throws {
    let mockSdJWTData = SdJWT.Mock.sampleDiplomaData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)
    XCTAssertFalse(credential.raw.isEmpty)
    XCTAssertFalse(credential.digests.isEmpty)
    XCTAssertEqual(3, credential.claims.count)
    XCTAssertEqual(credential.digests.count, credential.digests.count)
  }

  func testDecodeSdJwt_claimsStringValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimStringData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("firstName", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .string("Fritz"))
    XCTAssertEqual("z4sv7nVV9Q9gt8f17I2DtOIxkDMQ6ZYwSkl0KZW_cV8", credential.claims[0].digest)
  }

  func testDecodeSdJwt_claimsIntValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimIntData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("age", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .int(42))
    XCTAssertEqual("oAcDWPGsw1A94HMwA2d6ef1eEIeEYHBriruLeMLoJBM", credential.claims[0].digest)
  }

  func testDecodeSdJwt_claimsDoubleValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimDoubleData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("price", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .double(49.9))
    XCTAssertEqual("OkOQFjulIUtL3xA0-NTDQhwtlbHbOuj664p3S6EiOaU", credential.claims[0].digest)
  }

  func testDecodeSdJwt_claimsBoolValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimBoolData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("dateOfExpirationValidate", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .bool(true))
    XCTAssertEqual("CCkbPvZhVV_0rJipfsb5XI_6uSYUovGzlmFZi18DnaI", credential.claims[0].digest)
  }

  func testDecodeSdJwt_claimsDictionaryValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimDictionaryData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("signatureImage", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .dictionary(["mime": .string("image/png"), "counter": .int(12)]))
    XCTAssertEqual("r8Expl_ek7MtmtBM7pqxlNTmb-woJ9z6HSkGompSP7o", credential.claims[0].digest)
  }

  func testDecodeSdJwt_claimsArrayValue() throws {
    let mockSdJWTData = SdJWT.Mock.sampleOneClaimArrayData
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)

    XCTAssertFalse(credential.claims.isEmpty)
    XCTAssertEqual(1, credential.claims.count)
    XCTAssertEqual("infos", credential.claims[0].key)
    XCTAssertEqual(credential.claims[0].value, .array(
      [
        .string("info1"),
        .string("info2"),
        .bool(true),
        .bool(false),
        .int(1),
        .int(0),
      ]))
    XCTAssertEqual("rzxTtrgq-g4PPAmgNcUapw6A3dqlAfaFLOggnw2J3gc", credential.claims[0].digest)
  }

  func testDecodeSdJwt_digestNotFound() throws {
    let credential: SdJWT? = .Mock.sampleClaimInvalid
    XCTAssertNil(credential)
  }

  func testDecodeSdJwt_noDisclosures() throws {
    let mockSdJWTData = SdJWT.Mock.sampleNoDisclosures
    let credential = try JSONDecoder().decode(SdJWT.self, from: mockSdJWTData)
    XCTAssertTrue(credential.claims.isEmpty)
  }

}
