import BITActivity
import Factory

struct GetLastActivityUseCase: GetLastActivityUseCaseProtocol {

  init(activityRepository: ActivityRepositoryProtocol = Container.shared.activityRepository()) {
    self.activityRepository = activityRepository
  }

  func execute() async throws -> Activity? {
    try await activityRepository.getLast()
  }

  private let activityRepository: ActivityRepositoryProtocol
}
