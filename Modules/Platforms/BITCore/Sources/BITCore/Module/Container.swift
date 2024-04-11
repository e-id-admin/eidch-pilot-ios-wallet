import Factory
import Foundation

extension Container {

  public var processInfoService: Factory<ProcessInfoServiceProtocol> {
    self { ProcessInfoService() }
  }
}
