import Factory
import Foundation

@MainActor
extension Container {
  var splashScreenModule: ParameterFactory<() -> Void, SplashScreenModule> {
    self { SplashScreenModule(completed: $0) }
  }
}

extension Container {

  var userInactivityTimeout: Factory<TimeInterval> {
    self { 60 * 2 }
  }

  var splashScreenRouter: Factory<RootRouter> {
    self { RootRouter() }
  }

  var rootRouter: Factory<RootRouter> {
    self { RootRouter() }
  }

}
