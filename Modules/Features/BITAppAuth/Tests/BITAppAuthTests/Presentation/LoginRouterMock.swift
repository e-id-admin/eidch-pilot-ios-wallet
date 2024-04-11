import BITAppAuth
import Foundation

class LoginRouterMock: LoginRouter.Routes {

  var didCallLogin = false
  var didCallClose = false
  var didCallCloseOnComplete = false
  var didCallAppSettings = false
  var didCallDismiss = false
  var didCallPop = false
  var didCallPopToRoot = false

  func login(animated: Bool) {
    didCallLogin = true
  }

  func close(onComplete: (() -> Void)?) {
    didCallCloseOnComplete = true
  }

  func close() {
    didCallClose = true
  }

  func appSettings() {
    didCallAppSettings = true
  }

  func dismiss() {
    didCallDismiss = true
  }

  func pop() {
    didCallPop = true
  }

  func popToRoot() {
    didCallPopToRoot = true
  }

}
