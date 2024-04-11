import BITCore
import Factory
import XCTest
@testable import BITCredential

/// BIT Logic to be reactivated later in DisplayLocalizable
extension Array where Element: DisplayLocalizable {

  /// 1. User Preferred Languages
  /// 2. Default App Language
  /// 3 Fallback language
  /// 4. Nil
  fileprivate func findDisplayWithFallbackFor(preferredLanguageCodes: [UserLanguageCode] = Container.shared.preferredUserLanguageCodes()) -> DisplayLocalizable? {
    for preferredLanguageCode in preferredLanguageCodes {
      if
        let requestedDisplay = first(where: {
          guard let locale = $0.locale else { return false }
          return locale.starts(with: "\(preferredLanguageCode)-")
        })
      {
        return requestedDisplay
      }
    }

    return first(where: {
      guard let locale = $0.locale else { return false }
      return locale.starts(with: "\(UserLanguageCode.defaultAppLanguageCode)-")
    }) ??
      first(where: {
        guard let locale = $0.locale else { return false }
        return locale.starts(with: "\(UserLanguageCode.fallbackLanguageCode)-")
      })
  }

}

// MARK: - DisplayLocalizableBITTests

final class DisplayLocalizableBITTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  /// When a preferred language is found, take the first one
  func testFindUserPreferred_foundSeveral() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.english.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.french.rawValue),
    ]

    let display = displays.findDisplayWithFallbackFor(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display?.locale)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissEnglish.rawValue, display?.locale)
  }

  /// When at last a preferred language is found
  func testFindUserPreferred_foundOne() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.french.rawValue),
    ]

    let display = displays.findDisplayWithFallbackFor(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display?.locale)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissFrench.rawValue, display?.locale)
  }

  /// When no preferred language is found but german is available
  func testfallbackAppLanguage_german() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallbackFor(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNotNil(display)
    XCTAssertEqual(UserLocale.LocaleIdentifier.swissGerman.rawValue, display?.locale)
  }

  /// When no preferred language, german is not available but english is available
  func testfallbackLanguage_english() async throws {
    let displays = [
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      MockDisplay(locale: UserLocale.LocaleIdentifier.swissEnglish.rawValue),
    ]
    let preferredLanguageCodes = [
      UserLanguageCode(UserLanguageCode.LanguageIdentifier.italian.rawValue),
    ]

    let display = displays.findDisplayWithFallbackFor(preferredLanguageCodes: preferredLanguageCodes)

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

    let display = displays.findDisplayWithFallbackFor(preferredLanguageCodes: preferredLanguageCodes)

    XCTAssertNil(display)
  }
}

// MARK: - MockDisplay

fileprivate struct MockDisplay: DisplayLocalizable {
  var locale: UserLocale?
}
