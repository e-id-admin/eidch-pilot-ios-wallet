import Foundation
import Spyable

// MARK: - ClosableRoutes

@Spyable
public protocol ClosableRoutes: AnyObject {
  func close(onComplete: (() -> Void)?)
  func close()
  func pop()
  func popToRoot()
  func dismiss()
}
