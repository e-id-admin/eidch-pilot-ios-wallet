import BITHome
import Foundation

class HomeRouterMock: HomeRouter.Routes {

  var didCallDeeplink = false

  func deeplink(url: URL, animated: Bool) -> Bool {
    didCallDeeplink = true
    return true
  }

}
