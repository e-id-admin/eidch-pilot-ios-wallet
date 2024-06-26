import BITAppAuth
import BITOnboarding
import Factory
import Foundation
import UIKit

// MARK: - OnboardingScene

@MainActor
final class OnboardingScene: SceneManagerProtocol {

  // MARK: Lifecycle

  init() {
    hasDevicePinUseCase = Container.shared.hasDevicePinUseCase()
    module.viewModel.delegate = self
  }

  init(
    hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase())
  {
    self.hasDevicePinUseCase = hasDevicePinUseCase
    module.viewModel.delegate = self
  }

  // MARK: Internal

  weak var delegate: (any SceneManagerDelegate)?
  var hasDevicePinUseCase: HasDevicePinUseCaseProtocol
  var module: OnboardingFlowModule = Container.shared.onboardingFlowModule()

  func viewController() -> UIViewController {
    module.viewController
  }

  func willEnterForeground() {
    guard hasDevicePinUseCase.execute() else {
      delegate?.changeScene(to: NoDevicePinCodeScene.self, animated: false)
      return
    }
  }

}

// MARK: OnboardingFlowDelegate

extension OnboardingScene: OnboardingFlowDelegate {

  func didCompleteOnboarding() {
    delegate?.changeScene(to: AppScene.self)
    NotificationCenter.default.post(name: .didLogin, object: nil)
  }

}
