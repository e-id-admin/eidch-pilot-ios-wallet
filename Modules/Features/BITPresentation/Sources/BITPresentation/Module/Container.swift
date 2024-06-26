import BITSdJWT
import BITVault
import Factory
import Foundation

@MainActor
extension Container {

  public typealias PresentationCompletionHandler = () -> Void

  public var presentationMetadataViewModel: ParameterFactory<(RequestObject, CompatibleCredential, PresentationCompletionHandler), PresentationRequestMetadataViewModel> {
    self {
      PresentationRequestMetadataViewModel(requestObject: $0, selectedCredential: $1, completed: $2)
    }
  }

  public var presentationResultViewModel: ParameterFactory<(PresentationMetadata, PresentationCompletionHandler), PresentationResultViewModel> {
    self {
      PresentationResultViewModel(presentationMetadata: $0, completed: $1)
    }
  }

  public var presentationCredentialListViewModel: ParameterFactory<(RequestObject, [CompatibleCredential], PresentationCompletionHandler), PresentationCredentialListViewModel> {
    self {
      PresentationCredentialListViewModel(requestObject: $0, compatibleCredentials: $1, completed: $2)
    }
  }
}

extension Container {

  var presentationErrorViewModel: Factory<PresentationErrorViewModel> {
    self { PresentationErrorViewModel() }
  }

}

// MARK: - Repository

extension Container {

  public var presentationRepository: Factory<PresentationRepositoryProtocol> {
    self { PresentationRepository() }
  }
}

// MARK: - UseCase

extension Container {

  // MARK: Public

  public var fetchRequestObjectUseCase: Factory<FetchRequestObjectUseCaseProtocol> {
    self { FetchRequestObjectUseCase() }
  }

  public var submitPresentationUseCase: Factory<SubmitPresentationUseCaseProtocol> {
    self { SubmitPresentationUseCase() }
  }

  public var denyPresentationUseCase: Factory<DenyPresentationUseCaseProtocol> {
    self { DenyPresentationUseCase() }
  }

  public var getCompatibleCredentialsUseCase: Factory<GetCompatibleCredentialsUseCaseProtocol> {
    self { GetCompatibleCredentialsUseCase() }
  }

  public var presentationJWTGenerator: Factory<PresentationJWTGeneratorProtocol> {
    self { PresentationJWTGenerator() }
  }

  public var jwtManager: Factory<JWTManageable> {
    self { JWTManager() }
  }

  // MARK: Internal

  var keyManager: Factory<KeyManagerProtocol> {
    self { KeyManager() }
  }

}
