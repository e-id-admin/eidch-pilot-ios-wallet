import BITActivity
import BITAnalytics
import BITCore
import BITCredential
import BITCredentialShared
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
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    getLastActivityUseCase: GetLastActivityUseCaseProtocol = Container.shared.getLastActivityUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credentials = credentials
    self.isScannerPresented = isScannerPresented
    self.isMenuPresented = isMenuPresented
    self.getCredentialListUseCase = getCredentialListUseCase
    self.hasDeletedCredentialUseCase = hasDeletedCredentialUseCase
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.routes = routes
    self.notificationCenter = notificationCenter
    self.analytics = analytics
    self.getLastActivityUseCase = getLastActivityUseCase

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
    case fetchCredentials
    case didFetchCredentials(_ credentials: [Credential])
    case didFetchLastActivity(_ activity: Activity?)
    case checkCredentialsStatus
    case didCheckCredentialsStatus
    case didCheckCredentialsStatusWithError(_ error: Error)

    case refresh

    case setError(_ error: Error)
    case checkHasDeletedCredential
  }

  override public func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .fetchCredentials):
      return AnyPublisher.run {
        try await self.getCredentialListUseCase.execute()
      } onSuccess: { credentials in
        .didFetchCredentials(credentials)
      } onError: { error in
        .setError(error)
      }

    case (_, .didFetchCredentials(let credentials)):
      stateError = nil

      if self.credentials.isEmpty && credentials.isEmpty {
        return Just(.checkHasDeletedCredential).eraseToAnyPublisher()
      }

      self.credentials = credentials
      state = .results

      return AnyPublisher.run {
        try await self.getLastActivityUseCase.execute()
      } onSuccess: { activity in
        .didFetchLastActivity(activity)
      } onError: { error in
        .setError(error)
      }

    case (_, .refresh):
      return Just(.fetchCredentials).eraseToAnyPublisher()

    case (_, .checkCredentialsStatus):
      return AnyPublisher.run {
        try await self.checkAndUpdateCredentialStatusUseCase.execute(self.credentials)
      } onSuccess: { _ in
        .didCheckCredentialsStatus
      } onError: { error in
        self.analytics.log(error)
        return .didCheckCredentialsStatusWithError(error)
      }

    case (_, .didCheckCredentialsStatus),
         (_, .didCheckCredentialsStatusWithError(_)):
      return nil

    case (_, .setError(let error)):
      analytics.log(error)
      if credentials.isEmpty {
        state = .error
        lastActivity = nil
      }
      stateError = error

    case (_, .checkHasDeletedCredential):
      let hasDeletedCredential = hasDeletedCredentialUseCase.execute()
      state = hasDeletedCredential ? .emptyWithDeletedCredential : .emptyWithoutDeletedCredential

    case (_, .didFetchLastActivity(let activity)):
      lastActivity = activity

      guard let activity else {
        return nil
      }

      // Create a new instance to not have the view tight to the activity credential
      lastActivityCredential = activity.credential.copy()
    }

    return nil
  }

  // MARK: Internal

  var lastActivityCredential: Credential?
  @Published var credentials: [Credential] = []
  @Published var isScannerPresented: Bool = false
  @Published var isMenuPresented: Bool = false
  @Published var isCredentialDetailPresented = false
  @Published var lastActivity: Activity?
  @Published var isActivityDetailPresented: Bool = false
  @Published var isActivitiesListPresented: Bool = false

  func showCredentialDetails() {
    isCredentialDetailPresented = true
  }

  func showActivitiesList() {
    isActivitiesListPresented = true
  }

  func showActivityDetails() {
    guard lastActivity?.type != .credentialReceived else {
      return
    }

    isActivityDetailPresented = true
  }

  // MARK: Private

  private let notificationCenter: NotificationCenter
  private let routes: HomeRouter.Routes

  private let getCredentialListUseCase: GetCredentialListUseCaseProtocol
  private let hasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocol
  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
  private let getLastActivityUseCase: GetLastActivityUseCaseProtocol
  private let analytics: AnalyticsProtocol

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
