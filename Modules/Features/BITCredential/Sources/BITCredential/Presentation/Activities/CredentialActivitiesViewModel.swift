import BITActivity
import BITAnalytics
import BITCore
import BITCredentialShared
import BITDataStore
import Combine
import CoreData
import Factory
import SwiftUI

// MARK: - CredentialActivitiesViewModel

@MainActor
class CredentialActivitiesViewModel: StateMachine<CredentialActivitiesViewModel.State, CredentialActivitiesViewModel.Event> {

  // MARK: Lifecycle

  init(
    _ initialState: State = .loading,
    credential: Credential,
    isPresented: Binding<Bool> = .constant(true),
    getGroupedCredentialActivitiesUseCase: GetGroupedCredentialActivitiesUseCaseProtocol = Container.shared.getGroupedCredentialActivitiesUseCase(),
    deleteActivityUseCase: DeleteActivityUseCaseProtocol = Container.shared.deleteActivityUseCase(),
    dataStore: CoreDataStoreProtocol = Container.shared.dataStore(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credential = credential
    self.getGroupedCredentialActivitiesUseCase = getGroupedCredentialActivitiesUseCase
    self.deleteActivityUseCase = deleteActivityUseCase
    self.analytics = analytics
    self.dataStore = dataStore
    _isPresented = isPresented
    super.init(initialState)

    registerNotifications()
  }

  // MARK: Internal

  enum State: Equatable {
    case loading
    case results
    case empty
  }

  enum Event {
    case didAppear
    case fetchActivities
    case didFetchActivities(_ activities: [(key: String, value: [Activity])])
    case deleteActivity(_ activity: Activity)
    case didDeleteActivity
    case setError(_ error: Error)
    case close
  }

  @Binding var isPresented: Bool
  @Published var isActivityDetailPresented: Bool = false
  @Published var groupedActivities: [(key: String, value: [Activity])] = []
  @Published var selectedActivity: Activity? = nil

  func showActivityDetailView() {
    isActivityDetailPresented = true
  }

  override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .didAppear):
      return Just(.fetchActivities).eraseToAnyPublisher()

    case (.loading, .fetchActivities),
         (.results, .fetchActivities):
      return AnyPublisher.run {
        try await self.getGroupedCredentialActivitiesUseCase.execute(for: self.credential)
      } onSuccess: { activities in
        .didFetchActivities(activities)
      } onError: { error in
        .setError(error)
      }

    case (_, .didFetchActivities(let groupedActivities)):
      self.groupedActivities = groupedActivities
      state = groupedActivities.isEmpty ? .empty : .results

    case (_, .deleteActivity(let activity)):
      return AnyPublisher.run {
        try await self.deleteActivity(activity)
      } onSuccess: { _ in
        .didDeleteActivity
      } onError: { error in
        .setError(error)
      }

    case (_, .didDeleteActivity):
      if areAllGroupsEmpty() {
        state = .empty
      }

    case (_, .setError(let error)):
      analytics.log(error)
      stateError = error

    case (_, .close):
      isPresented.toggle()

    case (.empty, .fetchActivities):
      return nil
    }

    return nil
  }

  // MARK: Private

  private let credential: Credential
  private let deleteActivityUseCase: DeleteActivityUseCaseProtocol
  private let getGroupedCredentialActivitiesUseCase: GetGroupedCredentialActivitiesUseCaseProtocol
  private let analytics: AnalyticsProtocol
  private let dataStore: CoreDataStoreProtocol

  private func deleteActivity(_ activity: Activity) async throws {
    try await deleteActivityUseCase.execute(activity)

    if let groupIndex = groupedActivities.firstIndex(where: { $0.value.contains(where: { $0 == activity }) }) {
      groupedActivities[groupIndex].value.removeAll(where: { $0.id == activity.id })
    }

    groupedActivities.removeAll(where: { $0.value.isEmpty })
  }

  private func areAllGroupsEmpty() -> Bool {
    groupedActivities.allSatisfy(\.value.isEmpty)
  }

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
    guard
      let userInfo = notification.userInfo,
      (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.contains(where: { $0.entity.isKindOf(entity: ActivityEntity.entity()) }) ?? false
    else { return }

    Task {
      await send(event: .fetchActivities)
    }
  }
}
