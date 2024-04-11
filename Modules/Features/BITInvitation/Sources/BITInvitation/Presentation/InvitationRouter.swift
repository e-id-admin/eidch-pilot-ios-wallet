import BITCredential
import BITDeeplink
import BITNavigation
import Factory
import SwiftUI
import UIKit

// MARK: - InvitationRoutes

public protocol InvitationRoutes {
  func deeplink(url: URL, animated: Bool)
}

@MainActor
extension InvitationRoutes where Self: RouterProtocol {

  public func deeplink(url: URL, animated: Bool) {
    guard let topViewController = UIApplication.topViewController, !topViewController.className.contains("LoginHostingController") else {
      return
    }

    let deeplinkManager = DeeplinkManager(allowedRoutes: RootDeeplinkRoute.allCases)
    guard let route = try? deeplinkManager.dispatchFirst(url) else { return }

    switch route {
    case .credential:
      let module = Container.shared.invitationModule(url)
      let style = ModalOpeningStyle(animatedWhenPresenting: animated, modalPresentationStyle: .fullScreen)
      module.router.current = style
      let viewController = module.viewController

      open(viewController, on: topViewController, as: style)
    }
  }

  public func deeplink(url: URL) {
    deeplink(url: url, animated: true)
  }

}

// MARK: - InvitationRouter

final public class InvitationRouter: Router<UIViewController>, InvitationRouter.Routes {
  public typealias Routes = ClosableRoutes & CredentialOfferRoutes & InvitationRoutes
}
