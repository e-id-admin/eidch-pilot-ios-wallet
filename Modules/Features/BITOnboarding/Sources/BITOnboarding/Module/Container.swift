import BITSettings
import Factory

@MainActor
extension Container {

  // MARK: Public

  public var onboardingFlowModule: Factory<OnboardingFlowModule> {
    self { OnboardingFlowModule() }
  }

  // MARK: Internal

  var onBoardingFlowViewModel: ParameterFactory<OnboardingRouter.Routes, OnboardingFlowViewModel> {
    self { OnboardingFlowViewModel(routes: $0) }
  }

}

extension Container {

  // MARK: Public

  public var onboardingRouter: Factory<OnboardingRouter> {
    self { OnboardingRouter() }
  }

  // MARK: Internal

  var onboardingSuccessRepository: Factory<OnboardingSuccessRepositoryProtocol> {
    self { UserDefaultsOnboardingSuccessRepository() }
  }

  var onboardingSuccessUseCase: Factory<OnboardingSuccessUseCaseProtocol> {
    self { OnboardingSuccessUseCase() }
  }
}
