// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - L10n

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
  /// pilotWallet
  static let appName = L10n.tr("Localizable", "app_name", fallback: "pilotWallet")
  /// Es wurden keine Daten gefunden…
  static let emptyStateEmptyTitle = L10n.tr("Localizable", "emptyState_emptyTitle", fallback: "Es wurden keine Daten gefunden…")
  /// Ups, irgendetwas ist schief gelaufen!
  static let emptyStateErrorTitle = L10n.tr("Localizable", "emptyState_errorTitle", fallback: "Ups, irgendetwas ist schief gelaufen!")
  /// Für die gewählte Aktion ist eine Internetverbindung nötig. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es noch einmal.
  static let emptyStateOfflineMessage = L10n.tr("Localizable", "emptyState_offlineMessage", fallback: "Für die gewählte Aktion ist eine Internetverbindung nötig. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es noch einmal.")
  /// Noch einmal versuchen
  static let emptyStateOfflineRetryButton = L10n.tr("Localizable", "emptyState_offlineRetryButton", fallback: "Noch einmal versuchen")
  /// Fehlende Internetverbindung
  static let emptyStateOfflineTitle = L10n.tr("Localizable", "emptyState_offlineTitle", fallback: "Fehlende Internetverbindung")
  /// Zurück
  static let globalBack = L10n.tr("Localizable", "global_back", fallback: "Zurück")
  /// Zurück  zur Wallet
  static let globalBackHome = L10n.tr("Localizable", "global_back_home", fallback: "Zurück  zur Wallet")
  /// Abbrechen
  static let globalCancel = L10n.tr("Localizable", "global_cancel", fallback: "Abbrechen")
  /// Schliessen
  static let globalClose = L10n.tr("Localizable", "global_close", fallback: "Schliessen")
  /// n/a
  static let globalNotAssigned = L10n.tr("Localizable", "global_not_assigned", fallback: "n/a")
  /// Nochmals versuchen
  static let globalRetry = L10n.tr("Localizable", "global_retry", fallback: "Nochmals versuchen")
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
