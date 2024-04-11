import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class CredentialOfferModule {

  // MARK: Lifecycle

  public init(credential: Credential, router: CredentialOfferRouter = Container.shared.credentialOfferRouter()) {
    let router = router
    let viewModel = Container.shared.credentialOfferViewModel((credential, router, .constant(true)))
    let viewController = UIHostingController(rootView: CredentialOfferView(viewModel: viewModel))
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController

  // MARK: Internal

  let router: CredentialOfferRouter

  // MARK: Private

  private let viewModel: CredentialOfferViewModel

}
