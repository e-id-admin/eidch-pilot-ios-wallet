import CoreData
import Foundation

extension NSManagedObjectContext {
  public func deleteAllData() throws {
    guard let persistentStore = persistentStoreCoordinator?.persistentStores.last else { return }
    guard let url = persistentStoreCoordinator?.url(for: persistentStore) else { return }

    reset()
    try persistentStoreCoordinator?.remove(persistentStore)
    try FileManager.default.removeItem(at: url)
    try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
  }
}
