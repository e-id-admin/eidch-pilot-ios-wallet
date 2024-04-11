import BITCore
import BITCredential
import BITDataStore
import Combine
import CoreData
import Factory
import Foundation

// MARK: - HomeViewModel

public class HomeViewModel: StateMachine<HomeViewModel.State, HomeViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .results,
    routes: HomeRouter.Routes,
    credentials: [Credential] = [],
    isScannerPresented: Bool = false,
    isMenuPresented: Bool = false,
    notificationCenter: NotificationCenter = NotificationCenter.default,
    getCredentialListUseCase: GetCredentialListUseCaseProtocol = Container.shared.getCredentialListUseCase(),
    hasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocol = Container.shared.hasDeletedCredentialUseCase(),
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase())
  {
    self.credentials = credentials
    self.isScannerPresented = isScannerPresented
    self.isMenuPresented = isMenuPresented
    self.getCredentialListUseCase = getCredentialListUseCase
    self.hasDeletedCredentialUseCase = hasDeletedCredentialUseCase
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.routes = routes
    self.notificationCenter = notificationCenter

    super.init(initialState)
    registerNotifications()
  }

  // MARK: Public

  public enum State: Equatable {
    case results
    case error
    case emptyWithDeletedCredential
    case emptyWithoutDeletedCredential
  }

  public enum Event {
    case fetch
    case setCredentials(_ credentials: [Credential])
    case checkCredentialsStatus
    case didCheckCredentialsStatus
    case didCheckCredentialsStatusWithError(_ error: Error)

    case refresh

    case setError(_ error: Error)
    case void
    case checkHasDeletedCredential
  }

  @Published public var credentials: [Credential] = []
  @Published public var isScannerPresented: Bool = false
  @Published public var isMenuPresented: Bool = false

  override public func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .fetch):
      return AnyPublisher.run({ [weak self] in
        try await self?.fetch()
      }) { _ in
        .void
      } onError: { error in
        .setError(error)
      }

    case (_, .setCredentials(let credentials)):
      stateError = nil

      if self.credentials.isEmpty && credentials.isEmpty {
        return Just(.checkHasDeletedCredential).eraseToAnyPublisher()
      }

      self.credentials = credentials

      state = .results

    case (_, .refresh):
      return Just(.fetch).eraseToAnyPublisher()

    case (_, .checkCredentialsStatus):
      return AnyPublisher.run {
        try await self.checkAndUpdateCredentialStatusUseCase.execute(self.credentials)
      } onSuccess: { _ in
        .didCheckCredentialsStatus
      } onError: { error in
        .didCheckCredentialsStatusWithError(error)
      }

    case (_, .didCheckCredentialsStatus),
         (_, .didCheckCredentialsStatusWithError(_)):
      return nil

    case (_, .setError(let error)):
      if credentials.isEmpty {
        state = .error
      }
      stateError = error

    case (_, .void):
      break

    case (_, .checkHasDeletedCredential):
      let hasDeletedCredential = hasDeletedCredentialUseCase.execute()
      state = hasDeletedCredential ? .emptyWithDeletedCredential : .emptyWithoutDeletedCredential
    }

    return nil
  }

  // MARK: Private

  private let notificationCenter: NotificationCenter
  private let routes: HomeRouter.Routes

  private let getCredentialListUseCase: GetCredentialListUseCaseProtocol
  private let hasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocol
  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol

  private func fetch() async throws {
    async let credentials = try getCredentialListUseCase.execute()

    try await send(event: .setCredentials(credentials))
  }

  private func registerNotifications() {
    let managedObjectContext = Container.shared.dataStore().managedContext

    notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext)
    notificationCenter.addObserver(forName: .didLogin, object: nil, queue: .main, using: { [weak self] _ in self?.onDidLogin() })
  }

  @objc
  private func managedObjectContextObjectsDidChange(notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return }

    Task {
      let refresh = await withTaskGroup(of: Bool.self, returning: Bool.self) { taskGroup in
        let groups = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey]
        for group in groups where !((userInfo[group] as? Set<NSManagedObject>)?.isEmpty ?? true) {
          taskGroup.addTask {
            (userInfo[group] as? Set<NSManagedObject>)?.contains(where: { $0.entity.isKindOf(entity: CredentialEntity.entity()) }) ?? false
          }
        }

        return await taskGroup.contains(where: { $0 })
      }

      if refresh {
        await send(event: .refresh)
      }
    }
  }

  private func onDidLogin() {
    Task {
      await send(event: .checkCredentialsStatus)
    }
  }

}
