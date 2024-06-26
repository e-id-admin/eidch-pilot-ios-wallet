import BITCore
import Factory
import XCTest

@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class CredentialTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    Container.shared.preferredUserLocales.reset()
  }

  func testFindDisplay_additionalDisplays_available() async throws {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential: Credential = .Mock.sampleDisplaysAdditional
    let expectedLanguageCode = "de"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_additionalDisplays_notAvailable() async throws {
    let unmanagedCode = "cz"
    Container.shared.preferredUserLocales.register { [unmanagedCode] }
    let credential: Credential = .Mock.sampleDisplaysAdditional
    let expectedLanguageCode = "de"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_appDefaultDisplays() async throws {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential: Credential = .Mock.sampleDisplaysAppDefault
    let expectedLanguageCode = "de"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_fallbackDisplays() async throws {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential: Credential = .Mock.sampleDisplaysFallback
    let expectedLanguageCode = "en"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_unsupportedDisplays() async throws {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential: Credential = .Mock.sampleDisplaysUnsupported

    let display = credential.preferredDisplay
    XCTAssertNil(display)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertNil(claimDisplay)
    }
  }

  func testFindDisplay_emptyDisplays() async throws {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential: Credential = .Mock.sampleDisplaysEmpty

    let display = credential.preferredDisplay
    XCTAssertNil(display)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertNil(claimDisplay)
    }
  }

  func testCopy() {
    let mockCredential: Credential = .Mock.sample

    let credentialCopy = mockCredential.copy()

    XCTAssertEqual(mockCredential, credentialCopy)
  }

  // MARK: Private

  private func assertDisplays(credential: Credential, expectedLanguageCode: UserLanguageCode) {
    let display = credential.preferredDisplay
    XCTAssertNotNil(display)
    guard let display else { fatalError("display is nil") }
    XCTAssertTrue(display.locale?.starts(with: "\(expectedLanguageCode)-") ?? false)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertNotNil(claimDisplay)
      guard let claimDisplay else { fatalError("claim display is nil") }
      XCTAssertTrue(claimDisplay.locale?.starts(with: "\(expectedLanguageCode)-") ?? false)
    }
  }

}
