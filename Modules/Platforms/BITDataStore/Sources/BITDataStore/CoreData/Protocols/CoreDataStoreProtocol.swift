import CoreData
import Foundation
import Spyable

@Spyable
public protocol CoreDataStoreProtocol {
  var managedContext: NSManagedObjectContext { get }
  var container: NSPersistentContainer { get }

  func loadStores() throws
  func removeStores() throws

  func saveContext() throws
  func clearDatabase(mode: DataStoreClearingMode) throws
}
