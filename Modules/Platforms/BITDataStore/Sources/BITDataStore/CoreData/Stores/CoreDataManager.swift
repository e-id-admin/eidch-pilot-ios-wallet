import CoreData
import Foundation

class CoreDataManager: NSPersistentContainer {

  init(name: String) {
    guard
      var objectModelURL = Bundle.module.url(forResource: name, withExtension: "momd")
    else {
      fatalError("Unable to make the model URL")
    }

    var resource = URLResourceValues()
    resource.isExcludedFromBackup = true
    do {
      try objectModelURL.setResourceValues(resource)
    } catch {}

    guard
      let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
    else {
      fatalError("Failed to retrieve the object model")
    }

    super.init(name: name, managedObjectModel: objectModel)

    guard let firstDescription = persistentStoreDescriptions.first else {
      fatalError("Failed to retrive the persistentStoreDescription element")
    }
    firstDescription.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
  }

}
