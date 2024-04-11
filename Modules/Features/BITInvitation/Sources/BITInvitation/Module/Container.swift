import Factory
import Foundation

@MainActor
extension Container {

  // MARK: Public

  public var invitationModule: ParameterFactory<URL, InvitationModule> {
    self { InvitationModule(url: $0) }
  }

  public var invitationUrlViewModel: ParameterFactory<(URL, InvitationRouter.Routes), InvitationViewModel> {
    self { InvitationViewModel($0, routes: $1) }
  }

  public var invitationViewModel: Factory<InvitationViewModel> {
    self { InvitationViewModel() }
  }

  // MARK: Internal

  var cameraPermissionViewModel: ParameterFactory<InvitationCompletionHandler, CameraPermissionViewModel> {
    self { CameraPermissionViewModel($0) }
  }

}

extension Container {

  // MARK: Public

  public var invitationRouter: Factory<InvitationRouter> {
    self { InvitationRouter() }
  }

  public var validateCredentialOfferInvitationUrlUseCase: Factory<ValidateCredentialOfferInvitationUrlUseCaseProtocol> {
    self { ValidateCredentialOfferInvitationUrlUseCase() }
  }

  public var checkInvitationTypeUseCase: Factory<CheckInvitationTypeUseCaseProtocol> {
    self { CheckInvitationTypeUseCase() }
  }

  // MARK: Internal

  typealias InvitationCompletionHandler = () -> Void

}
