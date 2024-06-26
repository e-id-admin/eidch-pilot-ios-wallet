import BITDataStore
import Factory
import Foundation

// MARK: - CoreDataActivityRepositoryError

fileprivate enum CoreDataActivityRepositoryError: Error {
  case notFound
  case invalidEntity
}

// MARK: - CoreDataActivityRepository

public struct CoreDataActivityRepository: ActivityRepositoryProtocol {

  // MARK: Lifecycle

  init(database: CoreDataStoreProtocol = Container.shared.dataStore()) {
    self.database = database
  }

  // MARK: Public

  public func getAll() async throws -> [Activity] {
    try await database.managedContext.perform {
      let request = ActivityEntity.fetchRequest()
      let results = try database.managedContext.fetch(request)
      return results.compactMap { .init($0) }
    }
  }

  public func get(_ id: UUID) async throws -> Activity {
    let entity = try await getEntity(id)

    guard let activity = Activity(entity) else {
      throw CoreDataActivityRepositoryError.invalidEntity
    }

    return activity
  }

  public func delete(_ id: UUID) async throws {
    let entity = try await getEntity(id)
    return try await database.managedContext.perform {
      database.managedContext.delete(entity)
      try database.managedContext.save()
    }
  }

  public func getLast() async throws -> Activity? {
    try await database.managedContext.perform {
      let request = ActivityEntity.fetchLastRequest()
      let results = try database.managedContext.fetch(request)

      guard let entity = results.first, let activity = Activity(entity) else {
        return nil
      }

      return activity
    }
  }

  // MARK: Private

  private let database: CoreDataStoreProtocol

  private func getEntity(_ id: UUID) async throws -> ActivityEntity {
    try await database.managedContext.perform {
      let request = ActivityEntity.fetchRequest(byId: id)
      let results = try database.managedContext.fetch(request)

      guard let entity = results.first else {
        throw CoreDataActivityRepositoryError.notFound
      }

      return entity
    }
  }

}
