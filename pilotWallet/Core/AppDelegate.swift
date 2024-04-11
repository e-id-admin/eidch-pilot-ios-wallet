import Alamofire
import BITAppAuth
import BITCredential
import BITDataStore
import BITNetworking
import BITTheming
import Factory
import LocalAuthentication
import UIKit

// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    BITAppearance.setup()

    configureUserDefaults()
    configureKeychain()
    configureDataStore()
    configureSslPinning()
    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}

extension AppDelegate {

  private func configureKeychain() {
    guard UserDefaults.standard.bool(forKey: "rootOnboardingIsEnabled") else { return }
    try? Container.shared.resetLoginAttemptCounterUseCase().execute()
    try? Container.shared.unlockWalletUseCase().execute()
  }

  private func configureUserDefaults() {
    UserDefaults.standard.register(defaults: [
      "rootOnboardingIsEnabled": true,
      "optimizationOptIn": true,
      "isBiometricUsageAllowed": false,
      "hasDeletedCredential": false,
    ])
  }

  private func configureDataStore() {
    Task {
      do {
        try await Container.shared.dataStore().loadStores()
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }

  private func configureSslPinning() {
    NetworkContainer.shared.serverTrustManager.register {
      BITServerTrustManager()
    }
  }

}
