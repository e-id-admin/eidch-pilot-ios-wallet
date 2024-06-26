import BITAppAuth
import BITCore
import Factory
import Foundation
import UIKit

// MARK: - AppScene

@MainActor
final class AppScene: SceneManagerProtocol {

  // MARK: Lifecycle

  init() {
    hasDevicePinUseCase = Container.shared.hasDevicePinUseCase()
    router = Container.shared.rootRouter()

    registerNotifications()
  }

  init(hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase(), router: RootRouter.Routes = Container.shared.rootRouter()) {
    self.hasDevicePinUseCase = hasDevicePinUseCase
    self.router = router

    registerNotifications()
  }

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?

  func viewController() -> UIViewController {
    Container.shared.homeModule().viewController
  }

  func willPresentScene(from scene: any SceneManagerProtocol) {
    guard type(of: scene) != OnboardingScene.self else { return }
    router.login(animated: false)
  }

  func willEnterForeground() {
    guard hasDevicePinUseCase.execute() else {
      delegate?.changeScene(to: NoDevicePinCodeScene.self, animated: false)
      return
    }

    router.login(animated: false)
  }

  func didReceiveDeeplink(url: URL) {
    guard router.deeplink(url: url, animated: true) else { return }
    delegate?.didConsumeDeeplink()
  }

  // MARK: Private

  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocol
  private var router: RootRouter.Routes

  private func registerNotifications() {
    NotificationCenter.default.addObserver(forName: .userInactivityTimeout, object: nil, queue: .main) { _ in
      Task { @MainActor in self.didReceiveUserInactivityNotification() }
    }

    NotificationCenter.default.addObserver(forName: .didLogin, object: nil, queue: .main) { _ in
      Task { @MainActor in self.didReceiveLoginNotification() }
    }
  }

  private func didReceiveUserInactivityNotification() {
    router.login(animated: true)
  }

  private func didReceiveLoginNotification() {
    guard
      let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
      let url = sceneDelegate.deeplinkUrl
    else { return }
    didReceiveDeeplink(url: url)
  }

}
