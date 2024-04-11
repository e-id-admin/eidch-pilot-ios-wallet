import Factory
import Foundation
import OSLog

extension Container {

  public var dataStore: Factory<CoreDataStoreProtocol> {
    self { CoreDataStore(containerName: "pilotWallet") }.singleton
  }

  public var dataStoreLogger: Factory<Logger> {
    self { Logger(subsystem: "BITDataStore", category: "Database") }.cached
  }

}
