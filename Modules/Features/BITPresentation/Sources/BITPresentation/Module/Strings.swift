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
  /// Zurück zur Wallet
  static let globalErrorBackToHomeButton = L10n.tr("Localizable", "global_error_backToHome_button", fallback: "Zurück zur Wallet")
  /// Los
  static let globalErrorConfirmButton = L10n.tr("Localizable", "global_error_confirm_button", fallback: "Los")
  /// Ein Netzwerkaufruf hat nicht funktioniert.
  static let globalErrorNetworkMessage = L10n.tr("Localizable", "global_error_network_message", fallback: "Ein Netzwerkaufruf hat nicht funktioniert.")
  /// Keine Internetverbindung
  static let globalErrorNetworkTitle = L10n.tr("Localizable", "global_error_network_title", fallback: "Keine Internetverbindung")
  /// Zu den Einstellungen
  static let globalErrorNoDevicePinButton = L10n.tr("Localizable", "global_error_no_device_pin_button", fallback: "Zu den Einstellungen")
  /// Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.
  static let globalErrorNoDevicePinMessage = L10n.tr("Localizable", "global_error_no_device_pin_message", fallback: "Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.")
  /// Fehlender Smartphone-Code
  static let globalErrorNoDevicePinTitle = L10n.tr("Localizable", "global_error_no_device_pin_title", fallback: "Fehlender Smartphone-Code")
  /// Nochmals versuchen
  static let globalErrorRetryButton = L10n.tr("Localizable", "global_error_retry_button", fallback: "Nochmals versuchen")
  /// Bitte versuchen Sie es in ein paar Minuten nochmals.
  static let globalErrorUnexpectedMessage = L10n.tr("Localizable", "global_error_unexpected_message", fallback: "Bitte versuchen Sie es in ein paar Minuten nochmals.")
  /// Ups, irgendetwas ist schief gelaufen!
  static let globalErrorUnexpectedTitle = L10n.tr("Localizable", "global_error_unexpected_title", fallback: "Ups, irgendetwas ist schief gelaufen!")
  /// Etwas mit dem Wallet ging schief.
  static let globalErrorWalletMessage = L10n.tr("Localizable", "global_error_wallet_message", fallback: "Etwas mit dem Wallet ging schief.")
  /// Wallet Fehler
  static let globalErrorWalletTitle = L10n.tr("Localizable", "global_error_wallet_title", fallback: "Wallet Fehler")
  /// n/a
  static let globalNotAssigned = L10n.tr("Localizable", "global_not_assigned", fallback: "n/a")
  /// Nochmals versuchen
  static let globalRetry = L10n.tr("Localizable", "global_retry", fallback: "Nochmals versuchen")
  /// Daten übermitteln
  static let presentationAcceptButtonText = L10n.tr("Localizable", "presentation_accept_button_text", fallback: "Daten übermitteln")
  /// Angeforderte Daten
  static let presentationAttributesTitle = L10n.tr("Localizable", "presentation_attributes_title", fallback: "Angeforderte Daten")
  /// Die Verifizierung wurde abgebrochen. Ihre Daten wurden nicht übertragen.
  static let presentationDeclinedMessage = L10n.tr("Localizable", "presentation_declined_message", fallback: "Die Verifizierung wurde abgebrochen. Ihre Daten wurden nicht übertragen.")
  /// Abgebrochene Verifizierung
  static let presentationDeclinedTitle = L10n.tr("Localizable", "presentation_declined_title", fallback: "Abgebrochene Verifizierung")
  /// Anfrage ablehnen
  static let presentationDenyButtonText = L10n.tr("Localizable", "presentation_deny_button_text", fallback: "Anfrage ablehnen")
  /// Wenn Sie nach der Theorieprüfung einen QR-Code erhalten haben, scannen Sie diesen oder klicken Sie auf den SMS-Link. So erhalten Sie Ihren elektronischen Lernfahrausweis.
  ///
  /// Sie haben keinen QR-Code oder SMS erhalten?
  static let presentationErrorEmptyWalletMessage = L10n.tr("Localizable", "presentation_error_empty_wallet_message", fallback: "Wenn Sie nach der Theorieprüfung einen QR-Code erhalten haben, scannen Sie diesen oder klicken Sie auf den SMS-Link. So erhalten Sie Ihren elektronischen Lernfahrausweis.\n\nSie haben keinen QR-Code oder SMS erhalten?")
  /// https://www.eid.admin.ch/de/hilfe-support
  static let presentationErrorEmptyWalletSupportLink = L10n.tr("Localizable", "presentation_error_empty_wallet_support_link", fallback: "https://www.eid.admin.ch/de/hilfe-support")
  /// Hier finden Sie weitere Informationen
  static let presentationErrorEmptyWalletSupportText = L10n.tr("Localizable", "presentation_error_empty_wallet_support_text", fallback: "Hier finden Sie weitere Informationen")
  /// Leere Wallet
  static let presentationErrorEmptyWalletTitle = L10n.tr("Localizable", "presentation_error_empty_wallet_title", fallback: "Leere Wallet")
  /// Bitte versuchen Sie es in ein paar Minuten nochmals.
  static let presentationErrorMessage = L10n.tr("Localizable", "presentation_error_message", fallback: "Bitte versuchen Sie es in ein paar Minuten nochmals.")
  /// Der angefragte Nachweis ist in Ihrer pilotWallet nicht verfügbar.
  static let presentationErrorNoCompatibleCredentialMessage = L10n.tr("Localizable", "presentation_error_no_compatible_credential_message", fallback: "Der angefragte Nachweis ist in Ihrer pilotWallet nicht verfügbar.")
  /// Fehlender Nachweis
  static let presentationErrorNoCompatibleCredentialTitle = L10n.tr("Localizable", "presentation_error_no_compatible_credential_title", fallback: "Fehlender Nachweis")
  /// Ups, irgendetwas ist schief gelaufen!
  static let presentationErrorTitle = L10n.tr("Localizable", "presentation_error_title", fallback: "Ups, irgendetwas ist schief gelaufen!")
  /// Ihre übermittelten Daten
  static let presentationResultListTitle = L10n.tr("Localizable", "presentation_result_list_title", fallback: "Ihre übermittelten Daten")
  /// Ihre Daten wurden erfolgreich übermittelt
  static let presentationResultTitle = L10n.tr("Localizable", "presentation_result_title", fallback: "Ihre Daten wurden erfolgreich übermittelt")
  /// Bitte wählen Sie den Nachweis aus, den Sie vorweisen möchten.
  static let presentationSelectCredentialSubtitle = L10n.tr("Localizable", "presentation_select_credential_subtitle", fallback: "Bitte wählen Sie den Nachweis aus, den Sie vorweisen möchten.")
  /// Welchen Nachweis wollen Sie vorweisen?
  static let presentationSelectCredentialTitle = L10n.tr("Localizable", "presentation_select_credential_title", fallback: "Welchen Nachweis wollen Sie vorweisen?")
  /// Senden
  static let presentationSendButtonText = L10n.tr("Localizable", "presentation_send_button_text", fallback: "Senden")
  /// Ihre Informationen wurden erfolgreich übermittelt, aber Ihr Nachweis wurde vom ausstellenden Strassenverkehrsamt als ungültig erklärt (z.B. suspendierter Nachweis).
  ///
  /// Für mehr Informationen melden Sie sich bitte dort.
  static let presentationValidationErrorMessage = L10n.tr("Localizable", "presentation_validationError_message", fallback: "Ihre Informationen wurden erfolgreich übermittelt, aber Ihr Nachweis wurde vom ausstellenden Strassenverkehrsamt als ungültig erklärt (z.B. suspendierter Nachweis).\n\nFür mehr Informationen melden Sie sich bitte dort.")
  /// Ungültige Verifizierung
  static let presentationValidationErrorTitle = L10n.tr("Localizable", "presentation_validationError_title", fallback: "Ungültige Verifizierung")
  /// Unbekannter Verifizierer
  static let presentationVerifierNameUnknown = L10n.tr("Localizable", "presentation_verifier_name_unknown", fallback: "Unbekannter Verifizierer")
  /// möchte Ihren Nachweis überprüfen
  static let presentationVerifierText = L10n.tr("Localizable", "presentation_verifier_text", fallback: "möchte Ihren Nachweis überprüfen")
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
