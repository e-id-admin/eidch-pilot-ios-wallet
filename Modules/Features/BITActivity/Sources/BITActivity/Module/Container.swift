import BITCore
import Factory

extension Container {

  // MARK: Public

  public var activityRepository: Factory<ActivityRepositoryProtocol> {
    self { CoreDataActivityRepository() }
  }

  public var deleteActivityUseCase: Factory<DeleteActivityUseCaseProtocol> {
    self { DeleteActivityUseCase() }
  }

  // MARK: Internal

  var activityCellViewModel: ParameterFactory<Activity, ActivityCellViewModel> {
    self { ActivityCellViewModel($0) }
  }
}
