import Factory
import Foundation
import OSLog

extension Container {

  public var dataStore: Factory<CoreDataStoreProtocol> {
    self { CoreDataStore(containerName: "pilotWallet") }.singleton
  }

}
