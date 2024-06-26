import BITCore
import Factory
import Foundation

// MARK: - DisplayLocalizable

public protocol DisplayLocalizable {
  var locale: UserLocale? { get }
}

// MARK: - DisplayLocalizableError

enum DisplayLocalizableError: Error {
  case displayNotFound
}

extension Array where Element: DisplayLocalizable {

  /// 1. Default App Language
  /// 2. User Preferred Languages
  /// 3 Fallback language
  /// 4. Nil
  public func findDisplayWithFallback(preferredLanguageCodes: [UserLanguageCode] = Container.shared.preferredUserLanguageCodes()) -> DisplayLocalizable? {

    if
      let defaultAppLanguageDisplay = first(where: {
        guard let locale = $0.locale else { return false }
        return locale.starts(with: "\(UserLanguageCode.defaultAppLanguageCode)-")
      })
    {
      return defaultAppLanguageDisplay
    }

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
      return locale.starts(with: "\(UserLanguageCode.fallbackLanguageCode)-")
    })
  }

}
