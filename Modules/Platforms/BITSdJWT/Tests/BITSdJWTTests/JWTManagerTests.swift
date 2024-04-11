import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class JWTManagerTests: XCTestCase {

  func testCreateJWK() throws {
    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let jwk = try JWTManager().createJWK(from: SecKeyTestsHelper.getPublicKey(for: privateKey))
    XCTAssertFalse(jwk.isEmpty)
  }

  func testCreateCredentialJWT() throws {
    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let algorithm: JWTAlgorithm = .ES512
    let payloadData = try JSONEncoder().encode(JWTPayload(audience: "some://url.audience", nonce: "123456"))

    let jwt = try JWTManager().createJWT(
      payloadData: payloadData,
      algorithm: algorithm,
      did: "did:something",
      privateKey: privateKey)

    XCTAssertFalse(jwt.raw.isEmpty)
    XCTAssertEqual(3, jwt.raw.split(separator: ".").count)
  }

  func testCreateVpJWT() throws {
    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let algorithm: JWTAlgorithm = .ES512
    let payloadData = try JSONEncoder().encode(JWT.Mock.sample) // VP JWT is a simple JWT composed by a JWT-VC, nonce, jti and iss

    let jwt = try JWTManager().createJWT(
      payloadData: payloadData,
      algorithm: algorithm,
      did: "did:something",
      privateKey: privateKey)

    XCTAssertFalse(jwt.raw.isEmpty)
    XCTAssertEqual(3, jwt.raw.split(separator: ".").count)
  }

  func testHasValidSignature_valid() throws {
    let privateKey = SecKeyTestsHelper.createPrivateKey()
    let publicKey = SecKeyTestsHelper.getPublicKey(for: privateKey)
    let payloadData = try JSONEncoder().encode(JWTPayload(audience: "some://url.audience", nonce: "123456"))

    let jwt = try JWTManager().createJWT(
      payloadData: payloadData,
      algorithm: .ES512,
      did: "did:something",
      privateKey: privateKey)

    let hasValidSignature = JWTManager().hasValidSignature(jwt: jwt, publicKey: publicKey)
    XCTAssertTrue(hasValidSignature)
  }

  func testHasValidSignature_invalid() throws {
    let payloadData = try JSONEncoder().encode(JWTPayload(audience: "some://url.audience", nonce: "123456"))
    let jwt = try JWTManager().createJWT(
      payloadData: payloadData,
      algorithm: .ES512,
      did: "did:something",
      privateKey: SecKeyTestsHelper.createPrivateKey())

    let anotherPublicKey = SecKeyTestsHelper.getPublicKey(for: SecKeyTestsHelper.createPrivateKey())

    let hasValidSignature = JWTManager().hasValidSignature(jwt: jwt, publicKey: anotherPublicKey)
    XCTAssertFalse(hasValidSignature)
  }

  func testHasValidSignature_error() throws {
    let jwt: JWT = .Mock.sample
    let publicKey = SecKeyTestsHelper.getPublicKey(for: SecKeyTestsHelper.createPrivateKey())
    let hasValidSignature = JWTManager().hasValidSignature(jwt: jwt, publicKey: publicKey)
    XCTAssertFalse(hasValidSignature)
  }

}
