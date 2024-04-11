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
  /// Zurück zur Wallet
  static let cameraPermissionDeniedCloseButton = L10n.tr("Localizable", "cameraPermission_denied_closeButton", fallback: "Zurück zur Wallet")
  /// Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.
  ///
  /// Um QR-Codes zu scannen, muss die pilotWallet auf die Kamera zugreifen.
  static let cameraPermissionDeniedMessage = L10n.tr("Localizable", "cameraPermission_denied_message", fallback: "Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.\n\nUm QR-Codes zu scannen, muss die pilotWallet auf die Kamera zugreifen.")
  /// Zu den Einstellungen
  static let cameraPermissionDeniedSettingsButton = L10n.tr("Localizable", "cameraPermission_denied_settingsButton", fallback: "Zu den Einstellungen")
  /// Verweigerter Kamerazugriff
  static let cameraPermissionDeniedTitle = L10n.tr("Localizable", "cameraPermission_denied_title", fallback: "Verweigerter Kamerazugriff")
  /// Weiter
  static let cameraPermissionNotDeterminedAllowButton = L10n.tr("Localizable", "cameraPermission_notDetermined_allowButton", fallback: "Weiter")
  /// Ablehnen
  static let cameraPermissionNotDeterminedDenyButton = L10n.tr("Localizable", "cameraPermission_notDetermined_denyButton", fallback: "Ablehnen")
  /// Damit Sie via QR-Code Nachweise erhalten und vorweisen können, müssen Sie den Zugriff auf Ihre Kamera gewähren.
  static let cameraPermissionNotDeterminedMessage = L10n.tr("Localizable", "cameraPermission_notDetermined_message", fallback: "Damit Sie via QR-Code Nachweise erhalten und vorweisen können, müssen Sie den Zugriff auf Ihre Kamera gewähren.")
  /// Kamerazugriff
  static let cameraPermissionNotDeterminedTitle = L10n.tr("Localizable", "cameraPermission_notDetermined_title", fallback: "Kamerazugriff")
  /// Kamerazugriff
  static let cameraPermissionTitle = L10n.tr("Localizable", "cameraPermission_title", fallback: "Kamerazugriff")
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
  /// Leider ist bei der Ausstellung Ihres Nachweises ein Fehler aufgetreten. Der Nachweis kann nicht gespeichert werden.
  ///
  /// Bitte wenden Sie sich ans Strassenverkehrsamt Ausserrhoden.
  static let invitationErrorCredentialExpiredMessage = L10n.tr("Localizable", "invitation_error_credential_expired_message", fallback: "Leider ist bei der Ausstellung Ihres Nachweises ein Fehler aufgetreten. Der Nachweis kann nicht gespeichert werden.\n\nBitte wenden Sie sich ans Strassenverkehrsamt Ausserrhoden.")
  /// https://www.eid.admin.ch/de/hilfe-support
  static let invitationErrorCredentialExpiredMoreInfoLink = L10n.tr("Localizable", "invitation_error_credential_expired_more_info_link", fallback: "https://www.eid.admin.ch/de/hilfe-support")
  /// Weitere Informationen
  static let invitationErrorCredentialExpiredMoreInfoTitle = L10n.tr("Localizable", "invitation_error_credential_expired_more_info_title", fallback: "Weitere Informationen")
  /// Fehlerhafter Nachweis
  static let invitationErrorCredentialExpiredTitle = L10n.tr("Localizable", "invitation_error_credential_expired_title", fallback: "Fehlerhafter Nachweis ")
  /// Leider ist bei der Ausstellung Ihres Nachweises etwas schief gelaufen.
  ///
  /// Bitte wenden Sie sich an das Strassenverkehrsamt Appenzell Ausserrhoden.
  static let invitationErrorCredentialMismatchMessage = L10n.tr("Localizable", "invitation_error_credential_mismatch_message", fallback: "Leider ist bei der Ausstellung Ihres Nachweises etwas schief gelaufen.\n\nBitte wenden Sie sich an das Strassenverkehrsamt Appenzell Ausserrhoden.")
  /// Fehlerhafter Nachweis
  static let invitationErrorCredentialMismatchTitle = L10n.tr("Localizable", "invitation_error_credential_mismatch_title", fallback: "Fehlerhafter Nachweis ")
  /// Von diesem Aussteller werden keine Nachweise zugelassen.
  ///
  /// Zurzeit stellt nur das Strassenverkehrsamt Appenzell Ausserrhoden elektronische Lernfahrausweise aus.
  static let invitationErrorWrongIssuerMessage = L10n.tr("Localizable", "invitation_error_wrong_issuer_message", fallback: "Von diesem Aussteller werden keine Nachweise zugelassen.\n\nZurzeit stellt nur das Strassenverkehrsamt Appenzell Ausserrhoden elektronische Lernfahrausweise aus.")
  /// Unbekannter Austeller
  static let invitationErrorWrongIssuerTitle = L10n.tr("Localizable", "invitation_error_wrong_issuer_title", fallback: "Unbekannter Austeller")
  /// Sie haben den QR-Code eines unbekannten oder nicht zugelassenen Verifier eingelesen.
  static let invitationErrorWrongVerifierMessage = L10n.tr("Localizable", "invitation_error_wrong_verifier_message", fallback: "Sie haben den QR-Code eines unbekannten oder nicht zugelassenen Verifier eingelesen.")
  /// Unbekannter Verifier
  static let invitationErrorWrongVerifierTitle = L10n.tr("Localizable", "invitation_error_wrong_verifier_title", fallback: "Unbekannter Verifier")
  /// Fügen Sie bitten den Kontakt hinzu.
  static let invitationReviewTitle = L10n.tr("Localizable", "invitationReview_title", fallback: "Fügen Sie bitten den Kontakt hinzu.")
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
  /// Der QR-Code ist ungültig
  static let qrScannerErrorMessage = L10n.tr("Localizable", "qrScanner_error_message", fallback: "Der QR-Code ist ungültig")
  /// Licht ab
  static let qrScannerFlashLightButtonOff = L10n.tr("Localizable", "qrScanner_flash_light_button_off", fallback: "Licht ab")
  /// Licht an
  static let qrScannerFlashLightButtonOn = L10n.tr("Localizable", "qrScanner_flash_light_button_on", fallback: "Licht an")
  /// Bitte scannen Sie nur QR-Codes aus vertrauenswürdigen Quellen.
  static let qrScannerHint = L10n.tr("Localizable", "qrScanner_hint", fallback: "Bitte scannen Sie nur QR-Codes aus vertrauenswürdigen Quellen.")
  /// Hinweis schliessen
  static let qrScannerHintCloseButton = L10n.tr("Localizable", "qrScanner_hint_close_button", fallback: "Hinweis schliessen")
  /// Heute ist der Server etwas träge. Wir bitten Sie um etwas Geduld.
  static let qrScannerLoadingMessage = L10n.tr("Localizable", "qrScanner_loading_message", fallback: "Heute ist der Server etwas träge. Wir bitten Sie um etwas Geduld.")
  /// QR-Scanner
  static let qrScannerTitle = L10n.tr("Localizable", "qrScanner_title", fallback: "QR-Scanner")
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
