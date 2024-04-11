import AVFoundation
import BITCore
import BITCredential
import BITNetworking
import BITPresentation
import Combine
import Factory
import Foundation

// MARK: - InvitationViewModel

@MainActor
public class InvitationViewModel: StateMachine<InvitationViewModel.State, InvitationViewModel.Event> {

  // MARK: Lifecycle

  private init(_ initialState: State, useCases: UseCases = UseCases()) {
    self.useCases = useCases
    super.init(initialState)
  }

  public convenience init(useCases: UseCases = UseCases()) {
    self.init(AVCaptureDevice.authorizationStatus(for: .video) == .authorized ? .qrScanner : .permission, useCases: useCases)
  }

  public convenience init(_ url: URL, useCases: UseCases = UseCases()) {
    self.init(.loading, useCases: useCases)

    Task {
      await send(event: .setMetadataUrl(url))
    }
  }

  private convenience init(_ initialState: State, routes: InvitationRouter.Routes, useCases: UseCases = .init()) {
    self.init(initialState, useCases: useCases)
    self.routes = routes
  }

  public convenience init(routes: InvitationRouter.Routes, useCases: UseCases = .init()) {
    self.init(AVCaptureDevice.authorizationStatus(for: .video) == .authorized ? .qrScanner : .permission, routes: routes, useCases: useCases)
  }

  public convenience init(_ url: URL, routes: InvitationRouter.Routes, useCases: UseCases = .init()) {
    self.init(.loading, routes: routes, useCases: useCases)

    Task {
      await send(event: .setMetadataUrl(url))
    }
  }

  // MARK: Public

  public enum State: Equatable {
    case loading
    case permission
    case qrScanner

    case emptyWallet
    case noCompatibleCredentials
    case wrongIssuer
    case wrongVerifier
    case credentialMismatch
    case expiredInvitation
    case noInternetConnexion
  }

  public enum Event {
    case cameraPermissionIsAuthorized
    case setMetadataUrl(_ string: URL)
    case retry

    case checkInvitationType(_ url: URL)
    case didCheckInvitationType(_ type: InvitationType?, _ url: URL)

    case setError(_ error: Error)
    case void

    case close
  }

  @Published public var qrScannerError: Error?

  @Published public var isTorchAvailable: Bool = false
  @Published public var isTorchEnabled: Bool = false
  @Published public var isTipPresented: Bool = true
  @Published public var isOfferPresented: Bool = false
  @Published public var isCredentialSelectionPresented: Bool = false
  @Published public var isPresentationPresented: Bool = false

  @Published public var offer: CredentialOffer?
  @Published public var requestObject: RequestObject?

  @Published public var isScannerActive: Bool = true

  @Published public var compatibleCredentials: [CompatibleCredential] = []
  @Published public var isLoading: Bool = false

  @Published public var isPopupErrorPresented: Bool = false {
    didSet {
      isScannerActive = !isPopupErrorPresented
    }
  }

  @Published public var metadataUrl: URL? {
    didSet {
      guard let metadataUrl, isScannerActive else { return }

      isScannerActive = false
      isLoading = true
      Task {
        await send(event: .setMetadataUrl(metadataUrl))
      }
    }
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (.permission, .cameraPermissionIsAuthorized):
      state = .qrScanner

    case (.noInternetConnexion, .retry):
      state = .loading
      stateError = nil
      isScannerActive = true
      metadataUrl = invitationURL

    case
      (.loading, .setMetadataUrl(let url)),
      (.qrScanner, .setMetadataUrl(let url)):
      return Just(.checkInvitationType(url)).eraseToAnyPublisher()

    case
      (.loading, .checkInvitationType(let url)),
      (.qrScanner, .checkInvitationType(let url)):
      isScannerActive = false
      isLoading = true
      return AnyPublisher.run(withDelay: 0.5) {
        try await self.checkInvitationType(url)
      } onSuccess: { type in
        .didCheckInvitationType(type, url)
      } onError: { error in
        .setError(error)
      }

    case
      (.loading, .didCheckInvitationType(let type, let url)),
      (.qrScanner, .didCheckInvitationType(let type, let url)):
      return AnyPublisher.run {
        switch type {
        case .credentialOffer:
          try await self.processCredentialOffer(url: url)
        case .presentation:
          try await self.processPresentation(url: url)
        default: return
        }
      } onSuccess: { _ in
        .void
      } onError: { error in
        .setError(error)
      }

    case (_, .setError(let error)):
      handleSetErrorEvent(&state, error)

    case (_, .close):
      routes?.close()

    default: break
    }

    return nil
  }

  // MARK: Internal

  var requestId: String? = nil
  @Published var credential: Credential?

  // MARK: Private

  private enum InvitationError: Error {
    case invalidURL
    case missingRequestId
    case noCredentials
    case noCompatibleCredentials
    case invalidOffer
    case invalidSelectedCredential
  }

  private var routes: InvitationRouter.Routes?

  private var processCredentialOffer: Bool = false
  private var processPresentation: Bool = false

  private var useCases: UseCases
  private var invitationURL: URL?

}

extension InvitationViewModel {

  private func handleSetErrorEvent(_ state: inout State, _ error: Error) {
    isLoading = false
    stateError = error

    if error as? NetworkError == .pinning {
      isTorchEnabled = false
      invitationURL = nil
      state = processPresentation ? .wrongVerifier : .wrongIssuer
    } else if error as? FetchCredentialError == .expiredInvitation {
      isTorchEnabled = false
      invitationURL = nil
      state = .expiredInvitation
    } else if
      error as? CredentialJWTValidatorError == .credentialMismatch ||
      error as? CredentialJWTValidatorError == .invalidSignature ||
      error as? CredentialJWTValidatorError == .invalidJWT ||
      error as? CredentialJWTValidatorError == .invalidSdJWT
    {
      isTorchEnabled = false
      invitationURL = nil
      state = .credentialMismatch
    } else if error as? InvitationError == .noCredentials {
      isTorchEnabled = false
      invitationURL = nil
      state = .emptyWallet
    } else if error as? InvitationError == .noCompatibleCredentials {
      isTorchEnabled = false
      invitationURL = nil
      state = .noCompatibleCredentials
    } else if error as? NetworkError == .noConnection {
      state = .noInternetConnexion
    } else {
      isPopupErrorPresented = true
      invitationURL = nil
    }

    processPresentation = false
    processCredentialOffer = false
  }

  private func checkInvitationType(_ url: URL) async throws -> InvitationType {
    invitationURL = url
    return try await useCases.checkInvitationTypeUseCase.execute(url: url)
  }

  private func processCredentialOffer(url: URL) async throws {
    processCredentialOffer = true
    let credentialOffer = try useCases.validateCredentialOfferInvitationUrlUseCase.execute(url)
    credential = try await fetchAndSaveCredential(from: credentialOffer)
    isLoading = false
    isTorchEnabled = false

    if let routes, let credential {
      routes.credentialOffer(credential: credential)
    } else {
      isOfferPresented = true
    }

    processCredentialOffer = false
  }

  private func processPresentation(url: URL) async throws {
    processPresentation = true
    let requestObject = try await useCases.fetchRequestObjectUseCase.execute(url)

    var compatibleCredentials: [CompatibleCredential] = []
    do {
      compatibleCredentials = try await useCases.getCompatibleCredentialsUseCase.execute(requestObject: requestObject)
    } catch CompatibleCredentialsError.noCredentials {
      throw InvitationError.noCredentials
    } catch {
      throw InvitationError.noCompatibleCredentials
    }

    guard !compatibleCredentials.isEmpty else {
      throw InvitationError.noCompatibleCredentials
    }

    self.compatibleCredentials = compatibleCredentials
    self.requestObject = requestObject
    isLoading = false
    isTorchEnabled = false

    if compatibleCredentials.count > 1 {
      isCredentialSelectionPresented = true
    } else {
      isPresentationPresented = true
    }
    processPresentation = false
  }

  private func fetchAndSaveCredential(from offer: CredentialOffer) async throws -> Credential {
    guard let issuerUrl = URL(string: offer.issuer) else {
      throw InvitationError.invalidOffer
    }

    guard let selectedCredentialId = offer.credentials.first else {
      throw InvitationError.invalidSelectedCredential
    }

    let metadata = try await useCases.fetchMetadataUseCase.execute(from: issuerUrl)
    let metadataWrapper = CredentialMetadataWrapper(selectedCredentialSupportedId: selectedCredentialId, credentialMetadata: metadata)

    let sdJWT = try await useCases.fetchCredentialUseCase.execute(from: issuerUrl, metadataWrapper: metadataWrapper, credentialOffer: offer, accessToken: nil)
    let credential = try await useCases.saveCredentialUseCase.execute(sdJWT: sdJWT, metadataWrapper: metadataWrapper)

    do {
      return try await useCases.checkAndUpdateCredentialStatusUseCase.execute(for: credential)
    } catch {
      return credential
    }
  }

}

// MARK: InvitationViewModel.UseCases

extension InvitationViewModel {
  public struct UseCases {

    // MARK: Lifecycle

    public init(
      validateCredentialOfferInvitationUrlUseCase: ValidateCredentialOfferInvitationUrlUseCaseProtocol = Container.shared.validateCredentialOfferInvitationUrlUseCase(),
      fetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol = Container.shared.fetchRequestObjectUseCase(),
      checkInvitationTypeUseCase: CheckInvitationTypeUseCaseProtocol = Container.shared.checkInvitationTypeUseCase(),
      getCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol = Container.shared.getCompatibleCredentialsUseCase(),
      fetchMetadataUseCase: FetchMetadataUseCaseProtocol = Container.shared.fetchMetadataUseCase(),
      fetchCredentialUseCase: FetchCredentialUseCaseProtocol = Container.shared.fetchCredentialUseCase(),
      saveCredentialUseCase: SaveCredentialUseCaseProtocol = Container.shared.saveCredentialUseCase(),
      checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase())
    {
      self.validateCredentialOfferInvitationUrlUseCase = validateCredentialOfferInvitationUrlUseCase
      self.fetchRequestObjectUseCase = fetchRequestObjectUseCase
      self.checkInvitationTypeUseCase = checkInvitationTypeUseCase
      self.getCompatibleCredentialsUseCase = getCompatibleCredentialsUseCase
      self.fetchMetadataUseCase = fetchMetadataUseCase
      self.fetchCredentialUseCase = fetchCredentialUseCase
      self.saveCredentialUseCase = saveCredentialUseCase
      self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    }

    // MARK: Public

    public var validateCredentialOfferInvitationUrlUseCase: ValidateCredentialOfferInvitationUrlUseCaseProtocol
    public var fetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol
    public var checkInvitationTypeUseCase: CheckInvitationTypeUseCaseProtocol
    public var getCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol
    public var fetchMetadataUseCase: FetchMetadataUseCaseProtocol
    public var fetchCredentialUseCase: FetchCredentialUseCaseProtocol
    public var saveCredentialUseCase: SaveCredentialUseCaseProtocol
    public var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol

  }
}
