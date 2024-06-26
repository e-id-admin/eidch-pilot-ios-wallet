import BITActivity
import Spyable

@Spyable
public protocol GetLastActivityUseCaseProtocol {
  func execute() async throws -> Activity?
}
