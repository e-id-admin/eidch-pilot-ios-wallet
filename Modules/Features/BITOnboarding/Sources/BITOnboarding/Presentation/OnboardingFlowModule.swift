import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class OnboardingFlowModule {

  // MARK: Lifecycle

  public init(
    onComplete: (() -> Void)? = nil,
    router: OnboardingRouter = Container.shared.onboardingRouter())
  {
    let router = router
    let viewModel = Container.shared.onBoardingFlowViewModel(router)
    viewModel.onComplete = onComplete
    let view = OnboardingFlowView(viewModel: viewModel)
      .environment(\.font, .custom.body)
      .preferredColorScheme(.light)
    let viewController = UIHostingController(rootView: view)
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController
  public let viewModel: OnboardingFlowViewModel

  // MARK: Internal

  let router: OnboardingRouter
}
