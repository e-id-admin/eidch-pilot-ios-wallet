import BITCore
import Combine
import Factory
import Foundation

public class CredentialDetailsCardViewModel: StateMachine<CredentialDetailsCardViewModel.State, CredentialDetailsCardViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    credential: Credential,
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    deleteCredentialUseCase: DeleteCredentialUseCaseProtocol = Container.shared.deleteCredentialUseCase())
  {
    self.credential = credential
    self.deleteCredentialUseCase = deleteCredentialUseCase
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    super.init(initialState)
  }

  // MARK: Public

  public enum State: Equatable {
    case results
  }

  public enum Event {
    case didAppear
    case checkStatus
    case loadCredential(_ credential: Credential)
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .didAppear):
      return Just(.checkStatus).eraseToAnyPublisher()

    case (_, .checkStatus):
      state = .results

      return AnyPublisher.run {
        try await self.checkAndUpdateCredentialStatusUseCase.execute(for: self.credential)
      } onSuccess: { credential in
        .loadCredential(credential)
      } onError: { _ in
        .loadCredential(self.credential)
      }

    case (_, .loadCredential(let credential)):
      credentialDetailBody = .init(from: credential)
      state = .results
    }

    return nil
  }

  // MARK: Internal

  let credential: Credential
  var credentialDetailBody: CredentialDetailBody? = nil

  @Published var isCredentialDetailsPresented: Bool = false
  @Published var isPoliceQRCodePresented: Bool = false
  @Published var isDeleteCredentialPresented: Bool = false

  var qrPoliceQRcode: Data? {
    guard
      let qrImage = credential.claims.first(where: { $0.key == "policeQRImage" })?.value,
      let data = Data(base64URLEncoded: qrImage)
    else { return nil }

    return data
  }

  // MARK: Private

  private let deleteCredentialUseCase: DeleteCredentialUseCaseProtocol
  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
}
