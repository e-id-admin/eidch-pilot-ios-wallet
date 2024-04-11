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
  /// Los
  static let biometricSetupActionButton = L10n.tr("Localizable", "biometricSetup_actionButton", fallback: "Los")
  /// Möchten Sie Biometrics zum Entsperren der pilotWallet aktivieren?
  static let biometricSetupContent = L10n.tr("Localizable", "biometricSetup_content", fallback: "Möchten Sie Biometrics zum Entsperren der pilotWallet aktivieren?")
  /// Die pilotWallet ermöglicht es Ihnen, Ihren digitalen Nachweis mit biometrischen Daten zu sichern.
  static let biometricSetupDisabledContent = L10n.tr("Localizable", "biometricSetup_disabled_content", fallback: "Die pilotWallet ermöglicht es Ihnen, Ihren digitalen Nachweis mit biometrischen Daten zu sichern.")
  /// Zu den Einstellungen
  static let biometricSetupDisabledEnableButton = L10n.tr("Localizable", "biometricSetup_disabled_enableButton", fallback: "Zu den Einstellungen")
  /// Biometrics deaktiviert
  static let biometricSetupDisabledTitle = L10n.tr("Localizable", "biometricSetup_disabled_title", fallback: "Biometrics deaktiviert")
  /// Überspringen
  static let biometricSetupDismissButton = L10n.tr("Localizable", "biometricSetup_dismissButton", fallback: "Überspringen")
  /// FaceID
  static let biometricSetupFaceidText = L10n.tr("Localizable", "biometricSetup_faceid_text", fallback: "FaceID")
  /// Biometrics registrieren
  static let biometricSetupNoClass3ToSettingsButton = L10n.tr("Localizable", "biometricSetup_noClass3_toSettingsButton", fallback: "Biometrics registrieren")
  /// Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.
  static let biometricSetupReason = L10n.tr("Localizable", "biometricSetup_reason", fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.")
  /// Biometrics verwenden
  static let biometricSetupTitle = L10n.tr("Localizable", "biometricSetup_title", fallback: "Biometrics verwenden")
  /// TouchID
  static let biometricSetupTouchidText = L10n.tr("Localizable", "biometricSetup_touchid_text", fallback: "TouchID")
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
  /// Los
  static let onboardingBiometricButtonText = L10n.tr("Localizable", "onboarding_biometric_button_text", fallback: "Los")
  /// Den Code zur Bestätigung wiederholen.
  static let onboardingPinCodeConfirmationText = L10n.tr("Localizable", "onboarding_pin_code_confirmation_text", fallback: "Den Code zur Bestätigung wiederholen.")
  /// Code bestätigen
  static let onboardingPinCodeConfirmationTitle = L10n.tr("Localizable", "onboarding_pin_code_confirmation_title", fallback: "Code bestätigen")
  /// Sichern Sie Ihre pilotWallet, damit Ihre Nachweise geschützt sind.
  static let onboardingPinCodeText = L10n.tr("Localizable", "onboarding_pin_code_text", fallback: "Sichern Sie Ihre pilotWallet, damit Ihre Nachweise geschützt sind.")
  /// App mit Code sichern
  static let onboardingPinCodeTitle = L10n.tr("Localizable", "onboarding_pin_code_title", fallback: "App mit Code sichern")
  /// Datenschutzerklärung
  static let onboardingPrivacyLinkText = L10n.tr("Localizable", "onboarding_privacy_link_text", fallback: "Datenschutzerklärung")
  /// https://www.eid.admin.ch/de/pilotwallet-privacy
  static let onboardingPrivacyLinkValue = L10n.tr("Localizable", "onboarding_privacy_link_value", fallback: "https://www.eid.admin.ch/de/pilotwallet-privacy")
  /// Privacy by Design
  static let onboardingPrivacyPrimary = L10n.tr("Localizable", "onboarding_privacy_primary", fallback: "Privacy by Design")
  /// Ihre Daten werden ausschliesslich auf Ihrem Smartphone gespeichert. Sie bestimmen, wem Sie wann welche Ihrer Daten vorweisen.
  static let onboardingPrivacySecondary = L10n.tr("Localizable", "onboarding_privacy_secondary", fallback: "Ihre Daten werden ausschliesslich auf Ihrem Smartphone gespeichert. Sie bestimmen, wem Sie wann welche Ihrer Daten vorweisen.")
  /// Helfen Sie mit, die pilotWallet zu verbessern, indem Sie erlauben, dass anonymisierte Nutzungsdaten dem Entwicklungsteam zur Verfügung stehen.
  static let onboardingPrivacyToggleText = L10n.tr("Localizable", "onboarding_privacy_toggle_text", fallback: "Helfen Sie mit, die pilotWallet zu verbessern, indem Sie erlauben, dass anonymisierte Nutzungsdaten dem Entwicklungsteam zur Verfügung stehen.")
  /// https://www.eid.admin.ch/de/pilotwallet-privacy
  static let onboardingPrivacyOptionsDataPrivacyLink = L10n.tr("Localizable", "onboarding_privacyOptions_dataPrivacyLink", fallback: "https://www.eid.admin.ch/de/pilotwallet-privacy")
  /// Datenschutzerklärung
  static let onboardingPrivacyOptionsDataPrivacyLinkText = L10n.tr("Localizable", "onboarding_privacyOptions_dataPrivacyLinkText", fallback: "Datenschutzerklärung")
  /// Ihre Daten sind ausschliesslich auf Ihrem Smartphone gespeichert. Sie bestimmen, wer, wann und welche persönlichen Daten auslesen darf.
  static let onboardingPrivacyOptionsDescription = L10n.tr("Localizable", "onboarding_privacyOptions_description", fallback: "Ihre Daten sind ausschliesslich auf Ihrem Smartphone gespeichert. Sie bestimmen, wer, wann und welche persönlichen Daten auslesen darf.")
  /// Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.
  static let onboardingPrivacyOptionsSwitchDescription = L10n.tr("Localizable", "onboarding_privacyOptions_switchDescription", fallback: "Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.")
  /// Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.
  static let onboardingPrivacyOptionsSwitchDescriptionBold = L10n.tr("Localizable", "onboarding_privacyOptions_switchDescriptionBold", fallback: "Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.")
  /// Privacy by Design
  static let onboardingPrivacyOptionsTitle = L10n.tr("Localizable", "onboarding_privacyOptions_title", fallback: "Privacy by Design")
  /// Mit QR-Code ausweisen
  static let onboardingQrCodePrimary = L10n.tr("Localizable", "onboarding_qrCode_primary", fallback: "Mit QR-Code ausweisen")
  /// Scannen Sie den QR-Code Ihres Gegenübers. Die pilotWallet holt anschliessend Ihr Einverständnis ein, Ihre Daten zu übertragen.
  static let onboardingQrCodeSecondary = L10n.tr("Localizable", "onboarding_qrCode_secondary", fallback: "Scannen Sie den QR-Code Ihres Gegenübers. Die pilotWallet holt anschliessend Ihr Einverständnis ein, Ihre Daten zu übertragen. ")
  /// Überspringen
  static let onboardingSkip = L10n.tr("Localizable", "onboarding_skip", fallback: "Überspringen")
  /// Ein sicheres Zuhause für Ihre Nachweise
  static let onboardingWalletPrimary = L10n.tr("Localizable", "onboarding_wallet_primary", fallback: "Ein sicheres Zuhause für Ihre Nachweise")
  /// Willkommen in Ihrer pilotWallet.
  ///
  /// Hier bewahren Sie Ihre Nachweise sicher auf. Nur Sie haben Zugriff darauf.
  static let onboardingWalletSecondary = L10n.tr("Localizable", "onboarding_wallet_secondary", fallback: "Willkommen in Ihrer pilotWallet.\n\nHier bewahren Sie Ihre Nachweise sicher auf. Nur Sie haben Zugriff darauf.")
  /// pilotWallet einrichten und starten
  static let storageSetupText = L10n.tr("Localizable", "storageSetup_text", fallback: "pilotWallet einrichten und starten")
  /// pilotWallet einrichten
  static let storageSetupTitle = L10n.tr("Localizable", "storageSetup_title", fallback: "pilotWallet einrichten")

  /// Möchten Sie %s zum Entsperren der pilotWallet aktivieren?
  static func onboardingBiometricInfo(_ p1: UnsafePointer<CChar>) -> String {
    L10n.tr("Localizable", "onboarding_biometric_info", p1, fallback: "Möchten Sie %s zum Entsperren der pilotWallet aktivieren?")
  }

  /// Sie können weiterhin Ihren Code verwenden, sollte es mit der %s mal nicht klappen.
  static func onboardingBiometricPermissionReason(_ p1: UnsafePointer<CChar>) -> String {
    L10n.tr("Localizable", "onboarding_biometric_permission_reason", p1, fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit der %s mal nicht klappen.")
  }

  /// %s verwenden
  static func onboardingBiometricText(_ p1: UnsafePointer<CChar>) -> String {
    L10n.tr("Localizable", "onboarding_biometric_text", p1, fallback: "%s verwenden")
  }

  /// %s verwenden
  static func onboardingBiometricTitle(_ p1: UnsafePointer<CChar>) -> String {
    L10n.tr("Localizable", "onboarding_biometric_title", p1, fallback: "%s verwenden")
  }

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
