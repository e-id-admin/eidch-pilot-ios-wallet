import CoreData
import Foundation

// MARK: - CoreDataStore

public class InMemoryCoreDataStore: CoreDataStore {

  public override init(containerName: String) {
    super.init(containerName: containerName)
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
  }

}
