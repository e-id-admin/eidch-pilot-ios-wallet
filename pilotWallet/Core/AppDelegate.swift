import Alamofire
import BITAnalytics
import BITAppAuth
import BITCredential
import BITDataStore
import BITNetworking
import BITTheming
import Factory
import LocalAuthentication
import UIKit

// MARK: - AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Internal

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
    configureAnalyticsIfAllowed()

    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: Private

  private let dataStore = Container.shared.dataStore()
  private let analytics = Container.shared.analytics()

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
      "isBiometricUsageAllowed": false,
      "hasDeletedCredential": false,
    ])
  }

  private func configureDataStore() {
    do {
      try dataStore.loadStores()
    } catch {
      analytics.log(AnalyticsErrorEvent.loadDataStoreError(error))
      fatalError(error.localizedDescription)
    }
  }

  private func configureSslPinning() {
    NetworkContainer.shared.serverTrustManager.register {
      BITServerTrustManager()
    }
  }

  private func configureAnalyticsIfAllowed() {
    let providers = [
      DynatraceProvider(),
    ]

    let analytics = Container.shared.analytics()
    for provider in providers {
      analytics.register(provider)
    }
  }

}

// MARK: AppDelegate.AnalyticsErrorEvent

extension AppDelegate {

  private enum AnalyticsErrorEvent: AnalyticsErrorEventProtocol {
    case loadDataStoreError(_ error: Error)

    // MARK: Internal

    func error() -> any Error {
      switch self {
      case .loadDataStoreError(let error):
        error
      }
    }

    func name(_ provider: any AnalyticsProviderProtocol.Type) -> String {
      switch self {
      case .loadDataStoreError:
        "loadDataStoreError"
      }
    }

    func parameters(_ provider: any AnalyticsProviderProtocol.Type) -> Parameters {
      switch self {
      case .loadDataStoreError(let error):
        ["errorDescription": error.localizedDescription]
      }
    }
  }

}
