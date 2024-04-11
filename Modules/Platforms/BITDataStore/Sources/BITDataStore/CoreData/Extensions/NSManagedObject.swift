import CoreData
import Foundation

extension NSManagedObject {
  static var identifier: String {
    String(describing: self)
  }
}
