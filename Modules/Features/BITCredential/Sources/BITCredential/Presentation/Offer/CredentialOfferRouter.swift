import BITCredentialShared
import BITNavigation
import Factory
import UIKit

// MARK: - CredentialOfferRoutes

public protocol CredentialOfferRoutes {
  func credentialOffer(credential: Credential)
}

@MainActor
extension CredentialOfferRoutes where Self: RouterProtocol {
  public func credentialOffer(credential: Credential) {
    let module = Container.shared.credentialOfferModule(credential)
    let style = NavigationPushOpeningStyle()
    module.router.current = style

    let viewController = module.viewController
    open(viewController, on: self.viewController, as: style)
  }
}

// MARK: - CredentialOfferRouter

final public class CredentialOfferRouter: Router<UIViewController>, CredentialOfferRouter.Routes {
  public typealias Routes = ClosableRoutes
}
