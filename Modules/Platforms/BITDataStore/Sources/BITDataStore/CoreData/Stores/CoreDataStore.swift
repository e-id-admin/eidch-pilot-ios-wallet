import CoreData
import Factory
import Foundation

// MARK: - CoreDataStore

public class CoreDataStore: CoreDataStoreProtocol {

  // MARK: Lifecycle

  public init(containerName: String) {
    self.containerName = containerName
    container = Self.persistentContainer(name: containerName)
    managedContext = container.viewContext
  }

  // MARK: Public

  public var managedContext: NSManagedObjectContext
  public var containerName: String
  public var container: NSPersistentContainer

  public func loadStores() async throws {
    Container.shared.dataStoreLogger().debug("\(#file) \(#function): Start")
    if let url = container.persistentStoreDescriptions.first?.url?.absoluteString {
      Container.shared.dataStoreLogger().debug("🔐 \(url)")
    }

    try await withCheckedThrowingContinuation({ continuation in
      container.loadPersistentStores { _, error in
        if let error {
          return continuation.resume(with: .failure(error))
        }
        return continuation.resume()
      }
    }) as Void

    Container.shared.dataStoreLogger().debug("\(#file) \(#function): Done")
  }

  public func removeStores() throws {
    try clearDatabase(mode: .safe)
  }

  public func saveContext() throws {
    guard managedContext.hasChanges else { return }
    try managedContext.save()
  }

  public func clearDatabase(mode: DataStoreClearingMode = .complete) throws {
    Container.shared.dataStoreLogger().debug("\(#file) \(#function): Start")
    guard let stores = managedContext.persistentStoreCoordinator?.persistentStores else { return }

    for store in stores {
      try managedContext.persistentStoreCoordinator?.remove(store)

      guard mode == .complete else {
        Container.shared.dataStoreLogger().debug("\(#file) \(#function): Done -without removing the database")
        return
      }
      if let path = store.url?.absoluteString {
        try FileManager.default.removeItem(atPath: path)
      }
    }
    Container.shared.dataStoreLogger().debug("\(#file) \(#function): Done")
  }

  // MARK: Private

  private static func persistentContainer(name: String) -> NSPersistentContainer {
    CoreDataManager(name: name)
  }

}
