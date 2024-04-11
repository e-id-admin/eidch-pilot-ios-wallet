import BITCredential
import XCTest
@testable import BITCredentialMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore
@testable import BITVault

final class PresentationJWTGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyVault = VaultProtocolSpy()
    spyJwtManager = JWTManageableSpy()

    spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonReturnValue = mockPrivateKey
    spyVault.getPublicKeyForReturnValue = mockPublickKey
    spyJwtManager.createJWKFromReturnValue = mockJwk
    spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyReturnValue = mockJwt

    generator = PresentationJWTGenerator(vault: spyVault, jwtManager: spyJwtManager)
  }

  func testGenerate_oneClaimRequested() throws {
    let mockRequestObject: RequestObject = .Mock.sample
    let mockRawCredential: RawCredential = .Mock.sample
    let requestedClaims: [PresentationMetadata.Field] = [
      PresentationMetadata.Field(key: "firstName", value: "value", type: .string, displayName: "Firstname"),
    ]
    let mockPresentationMetadata = PresentationMetadata(
      attributes: requestedClaims,
      verifier: RequestObject.Mock.sample.clientMetadata)

    let jwt = try generator.generate(requestObject: mockRequestObject, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)

    XCTAssertEqual(mockJwt, jwt)
    try assertGenerate(withRequestedClaims: requestedClaims)
  }

  func testGenerate_severalClaimsRequested() throws {
    let mockRequestObject: RequestObject = .Mock.sample
    let mockRawCredential: RawCredential = .Mock.sample
    let requestedClaims: [PresentationMetadata.Field] = [
      PresentationMetadata.Field(key: "firstName", value: "value", type: .string, displayName: "Firstname"),
      PresentationMetadata.Field(key: "lastName", value: "value", type: .string, displayName: "Lastname"),
      PresentationMetadata.Field(key: "dateOfBirth", value: "value", type: .string, displayName: "Date of birth"),
    ]
    let mockPresentationMetadata = PresentationMetadata(
      attributes: requestedClaims,
      verifier: RequestObject.Mock.sample.clientMetadata)

    let jwt = try generator.generate(requestObject: mockRequestObject, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)

    XCTAssertEqual(mockJwt, jwt)
    try assertGenerate(withRequestedClaims: requestedClaims)
  }

  func testGenerate_missingClaim() throws {
    let mockRequestObject: RequestObject = .Mock.sample
    let mockRawCredential: RawCredential = .Mock.sample
    let requestedClaims: [PresentationMetadata.Field] = [
      PresentationMetadata.Field(key: "firstName", value: "value", type: .string, displayName: "Firstname"),
      PresentationMetadata.Field(key: "special-claim", value: "value", type: .string, displayName: "SpecialClaim"),
    ]
    let mockPresentationMetadata = PresentationMetadata(
      attributes: requestedClaims,
      verifier: RequestObject.Mock.sample.clientMetadata)

    do {
      _ = try generator.generate(requestObject: mockRequestObject, rawCredential: mockRawCredential, presentationMetadata: mockPresentationMetadata)
    } catch PresentationJWTGeneratorError.claimsMismatch {
      XCTAssertFalse(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
      XCTAssertFalse(spyVault.getPublicKeyForCalled)
      XCTAssertFalse(spyJwtManager.createJWKFromCalled)
      XCTAssertFalse(spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: Private

  private let mockPrivateKey: SecKey = SecKeyTestsHelper.createPrivateKey()
  private let mockPublickKey: SecKey = SecKeyTestsHelper.createPrivateKey()
  private let mockJwk: JWK = "mock-jwk"
  private let mockJwt: JWT = .Mock.sample

  // swiftlint:disable all
  private var spyVault: VaultProtocolSpy!
  private var spyJwtManager: JWTManageableSpy!
  private var generator: PresentationJWTGenerator!

  // swiftlint:enable all

  private func assertGenerate(withRequestedClaims requestedClaims: [PresentationMetadata.Field]) throws {
    XCTAssertTrue(spyVault.getPrivateKeyWithIdentifierAlgorithmContextReasonCalled)
    XCTAssertTrue(spyVault.getPublicKeyForCalled)
    XCTAssertTrue(spyJwtManager.createJWKFromCalled)
    XCTAssertEqual(spyJwtManager.createJWKFromReceivedPublicKey, mockPublickKey)
    XCTAssertTrue(spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyCalled)
    XCTAssertEqual(spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyReceivedArguments?.did, "did:jwk:\(mockJwk)")
    XCTAssertEqual(spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyReceivedArguments?.privateKey, mockPrivateKey)

    guard let vpJWTData = spyJwtManager.createJWTPayloadDataAlgorithmDidPrivateKeyReceivedArguments?.payloadData else {
      XCTFail("no vpJWTData sent to the jwtManager")
      return
    }
    let vpJWT: PresentationJWTGenerator.VpJWT = try JSONDecoder.decode(vpJWTData)
    guard let verifiableCredential: String = vpJWT.vp.verifiableCredential.first else {
      XCTFail("no verifiableCredential created in the generator")
      return
    }

    let parts = verifiableCredential.split(separator: "~")
    XCTAssertEqual(1 + requestedClaims.count, parts.count)
    XCTAssertEqual(SdJWT.disclosuresSeparator, verifiableCredential.last)
  }

}
