import BITCore
import BITCredential
import Combine
import Foundation

public class PresentationCredentialListViewModel: StateMachine<PresentationCredentialListViewModel.State, PresentationCredentialListViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    requestObject: RequestObject,
    compatibleCredentials: [CompatibleCredential],
    completed: (() -> Void)? = nil)
  {
    self.requestObject = requestObject
    self.compatibleCredentials = compatibleCredentials
    self.completed = completed
    verifier = requestObject.clientMetadata

    guard !compatibleCredentials.isEmpty else {
      super.init(.error)
      stateError = PresentationCredentialListError.noCredentialFound
      return
    }

    super.init(initialState)
  }

  // MARK: Public

  public enum State: Equatable {
    case results
    case error
  }

  public enum Event {
    case cancel
    case close
    case didSelectCredential(_ compatibleCredential: CompatibleCredential)
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .cancel):
      completed?()

    case (_, .close):
      completed?()

    case (_, .didSelectCredential(let credential)):
      selectedCredential = credential
      isMetadataPresented = true
    }

    return nil
  }

  // MARK: Internal

  enum PresentationCredentialListError: Error {
    case noCredentialFound
  }

  var requestObject: RequestObject
  var completed: (() -> Void)?
  var verifier: Verifier?

  @Published var compatibleCredentials: [CompatibleCredential]
  @Published var selectedCredential: CompatibleCredential?
  @Published var isMetadataPresented: Bool = false

}
