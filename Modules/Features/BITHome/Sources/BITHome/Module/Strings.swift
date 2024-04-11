// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - L10n

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
  /// Nachweisinfo
  static let credentialDetailTitle = L10n.tr("Localizable", "credential_detail_title", fallback: "Nachweisinfo")
  /// Ihre Wallet ist leer. Bitte wenden Sie sich an das Strassenverkehrsamt Appenzell Ausserrhoden.
  static let homeEmptyViewHadCredentialsText = L10n.tr("Localizable", "home_empty_view_had_credentials_text", fallback: "Ihre Wallet ist leer. Bitte wenden Sie sich an das Strassenverkehrsamt Appenzell Ausserrhoden.")
  /// Schön, dass Sie beim Piloten zum elektronischen Lernfahrausweis in Appenzell Ausserrhoden dabei sind.
  static let homeEmptyViewNoCredentialsIntroText = L10n.tr("Localizable", "home_empty_view_no_credentials_intro_text", fallback: "Schön, dass Sie beim Piloten zum elektronischen Lernfahrausweis in Appenzell Ausserrhoden dabei sind.")
  /// https://www.eid.admin.ch/de/pilotprojekte
  static let homeEmptyViewNoCredentialsMoreInfoLink = L10n.tr("Localizable", "home_empty_view_no_credentials_more_info_link", fallback: "https://www.eid.admin.ch/de/pilotprojekte")
  /// Weitere Informationen
  static let homeEmptyViewNoCredentialsMoreInfoText = L10n.tr("Localizable", "home_empty_view_no_credentials_more_info_text", fallback: "Weitere Informationen")
  /// Ich habe keine SMS oder QR-Code erhalten.
  static let homeEmptyViewNoCredentialsQrCodeText = L10n.tr("Localizable", "home_empty_view_no_credentials_qr_code_text", fallback: "Ich habe keine SMS oder QR-Code erhalten.")
  /// https://forms.eid.admin.ch/elfa
  static let homeEmptyViewNoCredentialsScanLink = L10n.tr("Localizable", "home_empty_view_no_credentials_scan_link", fallback: "https://forms.eid.admin.ch/elfa")
  /// Gratulation zur Theorieprüfung 🎉 Bitte SMS-Link anklicken oder QR-Code scannen, damit Sie Ihren elektronischen Lernfahrausweis in Ihre pilotWallet erhalten.
  static let homeEmptyViewNoCredentialsScanText = L10n.tr("Localizable", "home_empty_view_no_credentials_scan_text", fallback: "Gratulation zur Theorieprüfung 🎉 Bitte SMS-Link anklicken oder QR-Code scannen, damit Sie Ihren elektronischen Lernfahrausweis in Ihre pilotWallet erhalten.")
  /// Ihr erster elektronischer Lernfahrausweis
  static let homeEmptyViewNoCredentialsTitle = L10n.tr("Localizable", "home_empty_view_no_credentials_title", fallback: "Ihr erster elektronischer Lernfahrausweis")
  /// Scannen
  static let homeQrCodeScanButton = L10n.tr("Localizable", "home_qr_code_scan_button", fallback: "Scannen")
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
