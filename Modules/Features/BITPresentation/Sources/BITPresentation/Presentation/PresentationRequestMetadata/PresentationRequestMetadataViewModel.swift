import BITCore
import BITCredential
import Combine
import Factory
import Foundation

// MARK: - PresentationRequestMetadataViewModel

@MainActor
public class PresentationRequestMetadataViewModel: StateMachine<PresentationRequestMetadataViewModel.State, PresentationRequestMetadataViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    requestObject: RequestObject,
    selectedCredential: CompatibleCredential,
    submitPresentationUseCase: SubmitPresentationUseCaseProtocol = Container.shared.submitPresentationUseCase(),
    denyPresentationUseCase: DenyPresentationUseCaseProtocol = Container.shared.denyPresentationUseCase(),
    completed: (() -> Void)? = nil)
  {
    self.requestObject = requestObject
    self.completed = completed
    self.selectedCredential = selectedCredential
    self.submitPresentationUseCase = submitPresentationUseCase
    self.denyPresentationUseCase = denyPresentationUseCase

    do {
      presentationMetadata = try PresentationMetadata(selectedCredential, verifier: requestObject.clientMetadata)
      super.init(initialState)
    } catch {
      super.init(.error)
      stateError = error
    }
  }

  // MARK: Public

  public enum State: Equatable {
    case results
    case error
    case invalidCredentialError
  }

  public enum Event {
    case close
    case deny
    case submit
    case onSuccess
    case setError(_ error: Error)

    case retry
    case didDenyPresentation
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch event {
    case .close:
      completed?()

    case .didDenyPresentation:
      isRequestDeclineViewPresented = true

    case .deny:
      return AnyPublisher.run(withDelay: 0.5) {
        try await self.denyPresentationUseCase.execute(requestObject: self.requestObject)
      } onSuccess: {
        .didDenyPresentation
      } onError: { error in
        .setError(error)
      }

    case .submit:
      guard let presentationMetadata else {
        return Just(.setError(PresentationDefinitionError.presentationMetadataNotFound)).eraseToAnyPublisher()
      }

      guard let rawCredential = selectedCredential.credential.rawCredentials.sdJWT else {
        return Just(.setError(PresentationDefinitionError.invalidCredential)).eraseToAnyPublisher()
      }

      isLoading = true

      return AnyPublisher.run(withDelay: 0.5) {
        try await self.submitPresentationUseCase.execute(
          requestObject: self.requestObject,
          rawCredential: rawCredential,
          presentationMetadata: presentationMetadata)
      } onSuccess: {
        .onSuccess
      } onError: { error in
        .setError(error)
      }

    case .onSuccess:
      isResultViewPresented = true
      isLoading = false

    case .setError(let error):
      isLoading = false
      stateError = error

      guard let presentationError = error as? SubmitPresentationError, presentationError == .credentialInvalid else {
        state = .error
        return nil
      }

      state = .invalidCredentialError

    case .retry:
      state = .results
      stateError = nil
    }

    return nil
  }

  // MARK: Internal

  enum PresentationDefinitionError: Error {
    case noCompatibleCredentials
    case invalidRequestObject
    case invalidCredential
    case presentationMetadataNotFound
  }

  var completed: (() -> Void)?
  @Published var isLoading: Bool = false
  @Published var isResultViewPresented: Bool = false
  @Published var isRequestDeclineViewPresented: Bool = false
  @Published var presentationMetadata: PresentationMetadata?

  let selectedCredential: CompatibleCredential
  let requestObject: RequestObject

  // MARK: Private

  private let submitPresentationUseCase: SubmitPresentationUseCaseProtocol
  private let denyPresentationUseCase: DenyPresentationUseCaseProtocol
}
