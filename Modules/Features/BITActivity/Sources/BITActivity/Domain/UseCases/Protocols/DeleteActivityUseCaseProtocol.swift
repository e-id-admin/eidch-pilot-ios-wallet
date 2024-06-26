import Spyable

@Spyable
public protocol DeleteActivityUseCaseProtocol {
  func execute(_ activity: Activity) async throws
}
