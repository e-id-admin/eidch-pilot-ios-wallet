import BITActivity
import BITAnalytics
import BITCore
import BITCredentialShared
import BITDataStore
import Combine
import CoreData
import Factory
import Foundation

public class CredentialDetailsCardViewModel: StateMachine<CredentialDetailsCardViewModel.State, CredentialDetailsCardViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .loading,
    credential: Credential,
    dataStore: CoreDataStoreProtocol = Container.shared.dataStore(),
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    getLastCredentialActivitiesUseCase: GetLastCredentialActivitiesUseCaseProtocol = Container.shared.getLastCredentialActivitiesUseCase(),
    credentialDetailNumberOfActivitiesElements: Int = Container.shared.credentialDetailNumberOfActivitiesElements(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credential = credential
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.getLastCredentialActivitiesUseCase = getLastCredentialActivitiesUseCase
    self.analytics = analytics
    self.credentialDetailNumberOfActivitiesElements = credentialDetailNumberOfActivitiesElements
    self.dataStore = dataStore
    super.init(initialState)

    registerNotifications()
  }

  // MARK: Public

  public enum State: Equatable {
    case loading
    case results
  }

  public enum Event {
    case didAppear
    case checkStatus
    case getLastActivities
    case setActivities(_ activities: [Activity])
    case loadCredential(_ credential: Credential)
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .didAppear):
      return Just(.checkStatus).eraseToAnyPublisher()

    case (_, .checkStatus):
      return AnyPublisher.run {
        try await self.checkAndUpdateCredentialStatusUseCase.execute(for: self.credential)
      } onSuccess: { credential in
        .loadCredential(credential)
      } onError: { error in
        self.analytics.log(error)
        return .loadCredential(self.credential)
      }

    case (_, .loadCredential(let credential)):
      self.credential = credential
      credentialDetailBody = .init(from: credential)
      return Just(.getLastActivities).eraseToAnyPublisher()

    case (_, .getLastActivities):
      return AnyPublisher.run {
        try await self.getLastCredentialActivitiesUseCase.execute(for: self.credential, count: self.credentialDetailNumberOfActivitiesElements)
      } onSuccess: { activities in
        .setActivities(activities)
      } onError: { error in
        self.analytics.log(error)
        return .setActivities([])
      }

    case (_, .setActivities(let activities)):
      self.activities = activities
      state = .results
    }

    return nil
  }

  // MARK: Internal

  @Published var credential: Credential
  @Published var credentialDetailBody: CredentialDetailBody? = nil
  @Published var selectedActivity: Activity? = nil
  @Published var activities: [Activity] = []
  @Published var isCredentialDetailsPresented: Bool = false
  @Published var isPoliceQRCodePresented: Bool = false
  @Published var isDeleteCredentialPresented: Bool = false
  @Published var isActivitiesListPresented: Bool = false
  @Published var isActivityDetailPresented: Bool = false

  var hasActivities: Bool {
    !activities.isEmpty
  }

  var qrPoliceQRcode: Data? {
    guard
      let qrImage = credential.claims.first(where: { $0.key == "policeQRImage" })?.value,
      let data = Data(base64URLEncoded: qrImage)
    else { return nil }

    return data
  }

  func showActivitiesView() {
    isActivitiesListPresented = true
  }

  func showActivityDetail() {
    isActivityDetailPresented = true
  }

  // MARK: Private

  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
  private let getLastCredentialActivitiesUseCase: GetLastCredentialActivitiesUseCaseProtocol
  private let analytics: AnalyticsProtocol
  private let credentialDetailNumberOfActivitiesElements: Int
  private let dataStore: CoreDataStoreProtocol

  private func registerNotifications() {
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
      object: dataStore.managedContext,
      queue: .main,
      using: { notification in
        self.managedObjectContextObjectsDidChange(notification: notification)
      })
  }

  private func managedObjectContextObjectsDidChange(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    if (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.contains(where: { $0.entity.isKindOf(entity: ActivityEntity.entity()) }) ?? false {
      Task {
        await send(event: .getLastActivities)
      }
    }

    if (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.contains(where: { $0.entity.isKindOf(entity: CredentialEntity.entity()) }) ?? false {
      Task {
        await send(event: .checkStatus)
      }
    }
  }
}
