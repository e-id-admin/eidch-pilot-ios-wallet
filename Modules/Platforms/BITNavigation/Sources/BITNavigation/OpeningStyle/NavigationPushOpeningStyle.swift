import Foundation
import UIKit

// MARK: - NavigationPushOpeningStyle

public class NavigationPushOpeningStyle: NSObject {

  // MARK: Lifecycle

  public init(animation: OpeningStyleAnimation? = nil, isAnimated: Bool = true) {
    self.animation = animation
    self.isAnimated = isAnimated
  }

  // MARK: Public

  public weak var viewController: UIViewController?

  // MARK: Internal

  var animation: OpeningStyleAnimation?
  var isAnimated: Bool = true
  var completionHandler: (() -> Void)?

}

// MARK: OpeningStyle

extension NavigationPushOpeningStyle: OpeningStyle {

  public func open(_ viewController: UIViewController) {
    self.viewController?.navigationController?.delegate = self
    if let navigationController = self.viewController as? UINavigationController {
      navigationController.delegate = self
      navigationController.pushViewController(viewController, animated: isAnimated)
    } else {
      self.viewController?.navigationController?.delegate = self
      self.viewController?.navigationController?.pushViewController(viewController, animated: isAnimated)
    }
  }

  public func close(_ viewController: UIViewController, _ onComplete: (() -> Void)?) {
    pop(viewController)
  }

  public func pop(_ viewController: UIViewController) {
    guard let navigationController = self.viewController as? UINavigationController else { return }
    navigationController.popViewController(animated: isAnimated)
  }

  public func popToRoot(_ viewController: UIViewController) {
    guard let navigationController = self.viewController as? UINavigationController else { return }
    navigationController.popToRootViewController(animated: isAnimated)
  }

  public func dismiss(_ viewController: UIViewController) {
    self.viewController?.dismiss(animated: true)
  }
}

// MARK: UINavigationControllerDelegate

extension NavigationPushOpeningStyle: UINavigationControllerDelegate {

  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool)
  {
    completionHandler?()
  }

  public func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
  {
    guard let animation else { return nil }
    if operation == .push {
      animation.isPresenting = true
      return animation
    } else {
      animation.isPresenting = false
      return animation
    }
  }
}
