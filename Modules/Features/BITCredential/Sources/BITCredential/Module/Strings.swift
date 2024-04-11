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
  /// Abbrechen
  static let credentialDeleteCancelButton = L10n.tr("Localizable", "credential_delete_cancel_button", fallback: "Abbrechen")
  /// Nachweis entfernen
  static let credentialDeleteConfirmButton = L10n.tr("Localizable", "credential_delete_confirm_button", fallback: "Nachweis entfernen")
  /// Wollen Sie den ausgewählten Nachweis wirklich entfernen? Ein erneutes Hinzufügen dieses Nachweises ist danach aus Sicherheitsgründen nicht mehr möglich.
  ///
  /// In dem Fall muss ein neuer Nachweis beim Strassenverkehrsamt bestellt werden.
  ///
  /// Beachten Sie, dass dabei alle Daten aus der pilotWallet gelöscht werden.
  static let credentialDeleteText = L10n.tr("Localizable", "credential_delete_text", fallback: "Wollen Sie den ausgewählten Nachweis wirklich entfernen? Ein erneutes Hinzufügen dieses Nachweises ist danach aus Sicherheitsgründen nicht mehr möglich.\n\nIn dem Fall muss ein neuer Nachweis beim Strassenverkehrsamt bestellt werden.\n\nBeachten Sie, dass dabei alle Daten aus der pilotWallet gelöscht werden.")
  /// Nachweis endgültig entfernen
  static let credentialDeleteTitle = L10n.tr("Localizable", "credential_delete_title", fallback: "Nachweis endgültig entfernen")
  /// Nachweisinfo
  static let credentialDetailNavigationTitle = L10n.tr("Localizable", "credential_detail_navigation_title", fallback: "Nachweisinfo")
  /// Nachweisinfo
  static let credentialDetailTitle = L10n.tr("Localizable", "credential_detail_title", fallback: "Nachweisinfo")
  /// Nachweis entfernen
  static let credentialMenuDeleteText = L10n.tr("Localizable", "credential_menu_delete_text", fallback: "Nachweis entfernen")
  /// Nachweisinfo
  static let credentialMenuDetailsText = L10n.tr("Localizable", "credential_menu_details_text", fallback: "Nachweisinfo")
  /// Polizeikontrolle
  static let credentialMenuPoliceControlText = L10n.tr("Localizable", "credential_menu_police_control_text", fallback: "Polizeikontrolle")
  /// Nachweis
  static let credentialNavigationTitle = L10n.tr("Localizable", "credential_navigation_title", fallback: "Nachweis")
  /// Akzeptieren
  static let credentialOfferAcceptButton = L10n.tr("Localizable", "credential_offer_acceptButton", fallback: "Akzeptieren")
  /// Inhalt des Nachweises
  static let credentialOfferContentSectionTitle = L10n.tr("Localizable", "credential_offer_content_section_title", fallback: "Inhalt des Nachweises")
  /// Zurück zur Wallet
  static let credentialOfferErrorBackButton = L10n.tr("Localizable", "credential_offer_error_back_button", fallback: "Zurück zur Wallet")
  /// Fehlerhafter Nachweis
  static let credentialOfferInvalidCredentialErrorTitle = L10n.tr("Localizable", "credential_offer_invalid_credential_error_title", fallback: "Fehlerhafter Nachweis")
  /// Der Aussteller dieses QR-Codes ist nicht bekannt. Derzeit ist es nur möglich, elektronische Lernfahrausweise von Appenzell Ausserrhoden zu erhalten.
  static let credentialOfferInvalidIssuerErrorMessage = L10n.tr("Localizable", "credential_offer_invalid_issuer_error_message", fallback: "Der Aussteller dieses QR-Codes ist nicht bekannt. Derzeit ist es nur möglich, elektronische Lernfahrausweise von Appenzell Ausserrhoden zu erhalten.")
  /// Unbekannter Austeller
  static let credentialOfferInvalidIssuerErrorTitle = L10n.tr("Localizable", "credential_offer_invalid_issuer_error_title", fallback: "Unbekannter Austeller")
  /// möchte einen Nachweis ausstellen
  static let credentialOfferInvitation = L10n.tr("Localizable", "credential_offer_invitation", fallback: "möchte einen Nachweis ausstellen")
  /// Abbrechen
  static let credentialOfferRefuseConfirmationCancelButton = L10n.tr("Localizable", "credential_offer_refuse_confirmation_cancelButton", fallback: "Abbrechen")
  /// Wollen Sie den ausgewählten Nachweis wirklich löschen? Beachten Sie, dass Sie gelöschte Nachweise nicht wiederherstellen können.
  ///
  /// Einen neuen Nachweis müssen Sie bei Ihrem Strassenverkehrsamt bestellen.
  ///
  /// Beachten Sie, dass dabei alle Daten aus der pilotWallet gelöscht werden.
  static let credentialOfferRefuseConfirmationMessage = L10n.tr("Localizable", "credential_offer_refuse_confirmation_message", fallback: "Wollen Sie den ausgewählten Nachweis wirklich löschen? Beachten Sie, dass Sie gelöschte Nachweise nicht wiederherstellen können.\n\nEinen neuen Nachweis müssen Sie bei Ihrem Strassenverkehrsamt bestellen.\n\nBeachten Sie, dass dabei alle Daten aus der pilotWallet gelöscht werden.")
  /// Anfrage ablehnen
  static let credentialOfferRefuseConfirmationRefuseButton = L10n.tr("Localizable", "credential_offer_refuse_confirmation_refuseButton", fallback: "Anfrage ablehnen")
  /// Anfrage ablehnen
  static let credentialOfferRefuseConfirmationTitle = L10n.tr("Localizable", "credential_offer_refuse_confirmation_title", fallback: "Anfrage ablehnen")
  /// Anfrage ablehnen
  static let credentialOfferRefuseButton = L10n.tr("Localizable", "credential_offer_refuseButton", fallback: "Anfrage ablehnen")
  /// Sind Ihre Daten falsch? Bitte wenden Sie sich an Ihr Strassenverkehrsamt.
  static let credentialOfferSupportMessage = L10n.tr("Localizable", "credential_offer_support_message", fallback: "Sind Ihre Daten falsch? Bitte wenden Sie sich an Ihr Strassenverkehrsamt.")
  /// Ungültig
  static let credentialStatusInvalid = L10n.tr("Localizable", "credential_status_invalid", fallback: "Ungültig")
  /// Unbekannt
  static let credentialStatusUnknown = L10n.tr("Localizable", "credential_status_unknown", fallback: "Unbekannt")
  /// Gültig
  static let credentialStatusValid = L10n.tr("Localizable", "credential_status_valid", fallback: "Gültig")
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
  /// Bitte weisen Sie diesen QR-Code nur bei Polizeikontrollen vor.  Mit diesem QR-Code können Sie die Daten Ihres Lernfahrausweises der Polizei übermitteln.
  static let policeControlDescriptionText = L10n.tr("Localizable", "police_control_description_text", fallback: "Bitte weisen Sie diesen QR-Code nur bei Polizeikontrollen vor.  Mit diesem QR-Code können Sie die Daten Ihres Lernfahrausweises der Polizei übermitteln.")
  /// QR-Code vorweisen
  static let policeControlQrcodeScanText = L10n.tr("Localizable", "police_control_qrcode_scan_text", fallback: "QR-Code vorweisen")
  /// Polizeikontrolle
  static let policeControlTitle = L10n.tr("Localizable", "police_control_title", fallback: "Polizeikontrolle")
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
