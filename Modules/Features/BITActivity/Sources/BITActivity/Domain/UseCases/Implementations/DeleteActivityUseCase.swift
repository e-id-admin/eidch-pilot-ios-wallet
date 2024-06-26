import Factory

struct DeleteActivityUseCase: DeleteActivityUseCaseProtocol {
  init(activityRepository: ActivityRepositoryProtocol = Container.shared.activityRepository()) {
    self.activityRepository = activityRepository
  }

  func execute(_ activity: Activity) async throws {
    try await activityRepository.delete(activity.id)
  }

  private let activityRepository: ActivityRepositoryProtocol
}
