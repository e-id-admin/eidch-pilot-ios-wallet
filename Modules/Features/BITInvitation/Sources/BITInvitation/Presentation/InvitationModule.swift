import Factory
import Foundation
import SwiftUI
import UIKit

@MainActor
public class InvitationModule {

  // MARK: Lifecycle

  public init(url: URL, router: InvitationRouter = Container.shared.invitationRouter()) {
    let router = router
    let viewModel = Container.shared.invitationUrlViewModel((url, router))
    let viewController = UINavigationController(rootViewController: UIHostingController(rootView: InvitationView(viewModel: viewModel)))
    router.viewController = viewController

    self.router = router
    self.viewController = viewController
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController

  // MARK: Internal

  let router: InvitationRouter

  // MARK: Private

  private let viewModel: InvitationViewModel

}
