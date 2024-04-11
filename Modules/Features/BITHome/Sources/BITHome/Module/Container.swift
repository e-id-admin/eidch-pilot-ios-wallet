import Factory
import Foundation

@MainActor
extension Container {

  public var homeModule: Factory<HomeModule> {
    self { HomeModule() }
  }

  public var homeViewModel: ParameterFactory<HomeRouter.Routes, HomeViewModel> {
    self { HomeViewModel(routes: $0) }
  }

}

extension Container {

  public var homeRouter: Factory<HomeRouter> {
    self { HomeRouter() }
  }

}
