// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - L10n

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Unsere App erlaubt es nicht, jailbroken Geräte zu verwenden. Um mögliche Sicherheitslücken zu vermeiden, empfehlen wir Ihnen, Ihr Gerät zu entjailbreaken.
  public static let jailbreakText = L10n.tr("Localizable", "jailbreak_text", fallback: "Unsere App erlaubt es nicht, jailbroken Geräte zu verwenden. Um mögliche Sicherheitslücken zu vermeiden, empfehlen wir Ihnen, Ihr Gerät zu entjailbreaken.")
  /// Wir haben einen Jailbreak auf Ihrem System entdeckt
  public static let jailbreakTitle = L10n.tr("Localizable", "jailbreak_title", fallback: "Wir haben einen Jailbreak auf Ihrem System entdeckt")
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// MARK: - BundleToken

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable convenience_type
