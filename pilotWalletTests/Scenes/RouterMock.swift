import Foundation
@testable import pilotWallet

class RootRouterMock: RootRouter.Routes {

  var didCallLogin = false
  var didCallSplashScreen = false
  var didCallDeeplink = false

  func login(animated: Bool) {
    didCallLogin = true
  }

  func splashScreen(_ completed: @escaping () -> Void) {
    didCallSplashScreen = true
  }

  func deeplink(url: URL, animated: Bool) -> Bool {
    didCallDeeplink = true
    return true
  }

}
