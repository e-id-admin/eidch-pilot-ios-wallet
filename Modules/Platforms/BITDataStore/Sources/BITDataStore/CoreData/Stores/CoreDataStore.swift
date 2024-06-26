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

  public func loadStores() throws {
    var loadError: NSError?
    container.loadPersistentStores { _, error in
      loadError = error as NSError?
    }
    if let loadError {
      throw CoreDataStoreError.cannotLoadStores(error: loadError)
    }
  }

  public func removeStores() throws {
    try clearDatabase(mode: .safe)
  }

  public func saveContext() throws {
    guard managedContext.hasChanges else { return }
    try managedContext.save()
  }

  public func clearDatabase(mode: DataStoreClearingMode = .complete) throws {
    guard let stores = managedContext.persistentStoreCoordinator?.persistentStores else { return }

    for store in stores {
      try managedContext.persistentStoreCoordinator?.remove(store)

      guard mode == .complete else {
        return
      }
      if let path = store.url?.absoluteString {
        try FileManager.default.removeItem(atPath: path)
      }
    }
  }

  // MARK: Private

  private static func persistentContainer(name: String) -> NSPersistentContainer {
    CoreDataManager(name: name)
  }

}

// MARK: CoreDataStore.CoreDataStoreError

extension CoreDataStore {
  private enum CoreDataStoreError: Error {
    case cannotLoadStores(error: NSError)
  }
}
