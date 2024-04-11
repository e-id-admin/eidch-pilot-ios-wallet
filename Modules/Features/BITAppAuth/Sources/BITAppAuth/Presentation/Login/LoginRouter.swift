import BITCore
import BITNavigation
import Factory
import Foundation
import UIKit

// MARK: - LoginRouter

final public class LoginRouter: Router<UIViewController>, LoginRouter.Routes {
  public typealias Routes = ClosableRoutes & LoginRoutes
}
