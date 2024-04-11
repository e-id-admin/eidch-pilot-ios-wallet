import Factory
import Foundation

@MainActor
extension Container {

  var licencesViewModel: Factory<LicencesListViewModel> {
    self { LicencesListViewModel() }
  }

  var privacyViewModel: Factory<PrivacyViewModel> {
    self { PrivacyViewModel() }
  }
}

extension Container {
  public var fetchPackagesUseCase: Factory<FetchPackagesUseCaseProtocol> {
    self { FetchPackagesUseCase(filePath: "package-list") }
  }
}
