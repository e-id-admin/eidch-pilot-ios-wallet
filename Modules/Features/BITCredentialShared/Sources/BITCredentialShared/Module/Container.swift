import BITCore
import Factory
import Foundation

extension Container {

  // MARK: Public

  public var preferredUserLanguageCodes: Factory<[UserLanguageCode]> {
    self {
      self.preferredUserLocales().compactMap({
        guard let sequence = $0.split(separator: "-").first else { return nil }
        return String(sequence)
      })
    }
  }

  // MARK: Internal

  var preferredUserLocales: Factory <[UserLocale]> {
    self { Locale.preferredLanguages }
  }

}
