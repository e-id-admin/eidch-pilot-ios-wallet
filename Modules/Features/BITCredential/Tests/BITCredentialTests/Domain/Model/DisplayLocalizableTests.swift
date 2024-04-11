import BITCore
import Factory
import XCTest
@testable import BITCredential

// MARK: - DisplayLocalizableTests

final class DisplayLocalizableTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  /// When german is available and no preferred language is found, take german
  func testFindGerman() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissGerman.rawValue, display?.locale)
  }

  /// When german and preferred languages are found, take german
  func testFindGermanAndUserPreferredWithGerman() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.french.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.english.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.german.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display?.locale)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissGerman.rawValue, display?.locale)
  }

  /// When german and preferred languages are found, take german
  func testFindGermanAndUserPreferredWithoutGerman() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.french.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.english.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display?.locale)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissGerman.rawValue, display?.locale)
  }

  /// When german is not available but there is several preferred language, take the first one
  func testNoGermanButUserPreferred() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissItalian.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.french.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.english.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display?.locale)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissFrench.rawValue, display?.locale)
  }

  /// When no preferred language, german is not available but english is available
  func testfallbackEnglish() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissEnglish.rawValue, display?.locale)
  }

  /// When no preferred language, german is not available, english is not available
  func testNoFallbackAvailable() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallback(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNil(display)
  }
}

// MARK: - MockDisplay

fileprivate struct MockDisplay: DisplayLocalizable {
  var locale: UserLocale?
}
