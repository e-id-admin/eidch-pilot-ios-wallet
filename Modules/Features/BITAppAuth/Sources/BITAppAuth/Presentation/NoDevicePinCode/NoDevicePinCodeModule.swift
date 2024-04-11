import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class NoDevicePinCodeModule {

  // MARK: Lifecycle

  public init(onComplete: (() -> Void)?, router: NoDevicePinCodeRouter = Container.shared.noDevicePinRouter()) {
    let router = router
    let viewModel = Container.shared.noDevicePinCodeViewModel(router)
    viewModel.onComplete = onComplete
    let view = NoDevicePinCodeView(viewModel: viewModel)
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

  // MARK: Internal

  let router: NoDevicePinCodeRouter
  let viewModel: NoDevicePinCodeViewModel

}
