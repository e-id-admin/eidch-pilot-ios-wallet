// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - L10n

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// pilotWallet
  public static let appName = L10n.tr("Localizable", "app_name", fallback: "pilotWallet")
  /// Zurück
  public static let globalBack = L10n.tr("Localizable", "global_back", fallback: "Zurück")
  /// Zurück  zur Wallet
  public static let globalBackHome = L10n.tr("Localizable", "global_back_home", fallback: "Zurück  zur Wallet")
  /// Abbrechen
  public static let globalCancel = L10n.tr("Localizable", "global_cancel", fallback: "Abbrechen")
  /// Schliessen
  public static let globalClose = L10n.tr("Localizable", "global_close", fallback: "Schliessen")
  /// Zurück zur Wallet
  public static let globalErrorBackToHomeButton = L10n.tr("Localizable", "global_error_backToHome_button", fallback: "Zurück zur Wallet")
  /// Los
  public static let globalErrorConfirmButton = L10n.tr("Localizable", "global_error_confirm_button", fallback: "Los")
  /// Ein Netzwerkaufruf hat nicht funktioniert.
  public static let globalErrorNetworkMessage = L10n.tr("Localizable", "global_error_network_message", fallback: "Ein Netzwerkaufruf hat nicht funktioniert.")
  /// Keine Internetverbindung
  public static let globalErrorNetworkTitle = L10n.tr("Localizable", "global_error_network_title", fallback: "Keine Internetverbindung")
  /// Zu den Einstellungen
  public static let globalErrorNoDevicePinButton = L10n.tr("Localizable", "global_error_no_device_pin_button", fallback: "Zu den Einstellungen")
  /// Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.
  public static let globalErrorNoDevicePinMessage = L10n.tr("Localizable", "global_error_no_device_pin_message", fallback: "Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.")
  /// Fehlender Smartphone-Code
  public static let globalErrorNoDevicePinTitle = L10n.tr("Localizable", "global_error_no_device_pin_title", fallback: "Fehlender Smartphone-Code")
  /// Nochmals versuchen
  public static let globalErrorRetryButton = L10n.tr("Localizable", "global_error_retry_button", fallback: "Nochmals versuchen")
  /// Bitte versuchen Sie es in ein paar Minuten nochmals.
  public static let globalErrorUnexpectedMessage = L10n.tr("Localizable", "global_error_unexpected_message", fallback: "Bitte versuchen Sie es in ein paar Minuten nochmals.")
  /// Ups, irgendetwas ist schief gelaufen!
  public static let globalErrorUnexpectedTitle = L10n.tr("Localizable", "global_error_unexpected_title", fallback: "Ups, irgendetwas ist schief gelaufen!")
  /// Etwas mit dem Wallet ging schief.
  public static let globalErrorWalletMessage = L10n.tr("Localizable", "global_error_wallet_message", fallback: "Etwas mit dem Wallet ging schief.")
  /// Wallet Fehler
  public static let globalErrorWalletTitle = L10n.tr("Localizable", "global_error_wallet_title", fallback: "Wallet Fehler")
  /// n/a
  public static let globalNotAssigned = L10n.tr("Localizable", "global_not_assigned", fallback: "n/a")
  /// Nochmals versuchen
  public static let globalRetry = L10n.tr("Localizable", "global_retry", fallback: "Nochmals versuchen")
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
