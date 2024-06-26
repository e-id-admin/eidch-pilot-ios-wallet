import Foundation
import Spyable

@Spyable
public protocol ActivityRepositoryProtocol {
  func getAll() async throws -> [Activity]
  func get(_ id: UUID) async throws -> Activity
  func getLast() async throws -> Activity?
  func delete(_ id: UUID) async throws
}
