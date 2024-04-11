import BITAppAuth
import BITHome
import Factory
import SwiftUI

// MARK: - SceneDelegate

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: Internal

  @AppStorage("rootOnboardingIsEnabled") var isOnboardingEnabled: Bool = true

  var window: UIWindow?

  var deeplinkUrl: URL?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)

    registerNotifications()

    window?.rootViewController = splashScreenViewController(onComplete: { [weak self] in
      guard let self else { return }
      isSplashScreenCompleted = true
      guard !tryToSwitchToRootBlockingViewControllers() else { return }

      isWillEnterForegroundAllowed = true
      switchRootViewController(to: homeViewController(), on: window)

      router.login(animated: false)
    })

    if let url = connectionOptions.urlContexts.first?.url {
      deeplinkUrl = url
    }

    window?.makeKeyAndVisible()
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    hidePrivacyOverlayView()

    NotificationCenter.default.post(name: .willEnterForeground, object: nil)
    guard isSplashScreenCompleted else { return }
    guard isWillEnterForegroundAllowed else {
      tryToSwitchToRootBlockingViewControllers()
      return
    }

    guard hasDevicePinUseCase.execute() else { return switchRootViewController(to: noDevicePinCodeViewController(), on: window) }
    guard !isOnboardingEnabled else { return switchRootViewController(to: onboardingViewController(), on: window) }

    router.login(animated: false)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    deeplinkUrl = url
    if didLogin {
      didReceiveDeeplink(url: url)
    }
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    hidePrivacyOverlayView()
  }

  func sceneWillResignActive(_ scene: UIScene) {
    showPrivacyOverlayView()
  }

  // MARK: Private

  private enum Defaults {
    static let rootViewControllerAnimationDuration = 0.3
  }

  private var isWillEnterForegroundAllowed = false
  private var isSplashScreenCompleted = false
  private var didLogin: Bool = false

  private let hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase()
  private var router = RootRouter()

  private lazy var privacyOverlayView: UIView = {
    let splashscreenView = SplashScreen()
    let splashscreenHostingController = UIHostingController(rootView: splashscreenView)
    splashscreenHostingController.view.frame = UIScreen.main.bounds

    return splashscreenHostingController.view
  }()

}

extension SceneDelegate {

  @discardableResult
  private func tryToSwitchToRootBlockingViewControllers() -> Bool {
    guard hasDevicePinUseCase.execute() else {
      switchRootViewController(to: noDevicePinCodeViewController(), on: window)
      return true
    }
    guard !isOnboardingEnabled else {
      switchRootViewController(to: onboardingViewController(), on: window)
      return true
    }
    return false
  }

  private func switchRootViewController(to vc: UIViewController, on window: UIWindow?) {
    guard let window, window.rootViewController?.className != vc.className else { return }
    UIView.transition(with: window, duration: Defaults.rootViewControllerAnimationDuration, options: .transitionCrossDissolve, animations: {
      self.window?.rootViewController = vc
      self.window?.makeKeyAndVisible()
    }, completion: nil)
  }

  private func homeViewController() -> UIViewController {
    Container.shared.homeModule().viewController
  }

  private func onboardingViewController() -> UIViewController {
    let onComplete = { [weak self] in
      guard let self else { return }
      isWillEnterForegroundAllowed = true
      switchRootViewController(to: homeViewController(), on: window)
      NotificationCenter.default.post(name: .didLogin, object: nil)
    }

    return Container.shared.onboardingFlowModule(onComplete).viewController
  }

  private func noDevicePinCodeViewController() -> UIViewController {
    let onComplete = { [weak self] in
      guard let self else { return }
      isWillEnterForegroundAllowed = true
      if isOnboardingEnabled {
        switchRootViewController(to: onboardingViewController(), on: window)
      } else {
        switchRootViewController(to: homeViewController(), on: window)
        router.login(animated: false)
      }
    }

    return Container.shared.noDevicePinCodeModule(onComplete).viewController
  }

  private func splashScreenViewController(onComplete completed: @escaping () -> Void) -> UIViewController {
    if #available(iOS 17.0, *) {
      let view = AnimatedSplashScreen(completed: completed)
      return UIHostingController(rootView: view)
    } else {
      let view = SplashScreen(completed: completed)
      return UIHostingController(rootView: view)
    }
  }

  private func registerNotifications() {
    NotificationCenter.default.addObserver(forName: .didLogin, object: nil, queue: .main) { [weak self] _ in
      guard let self else { return }
      didLogin = true
      if let url = deeplinkUrl {
        didReceiveDeeplink(url: url, animated: true)
      }
    }

    NotificationCenter.default.addObserver(forName: .loginRequired, object: nil, queue: .main) { [weak self] _ in
      guard let self else { return }
      didLogin = false
    }
  }
}

// MARK: - Deeplink

extension SceneDelegate {

  private func didReceiveDeeplink(url: URL, animated: Bool = true) {
    router.deeplink(url: url, animated: animated)
    deeplinkUrl = nil
  }

}

// MARK: - ProtectionView

extension SceneDelegate {

  private func showPrivacyOverlayView() {
    window?.addSubview(privacyOverlayView)
  }

  private func hidePrivacyOverlayView() {
    guard let subview = window?.subviews.last, subview == privacyOverlayView else {
      return
    }

    subview.removeFromSuperview()
  }
}
