import Foundation
import Spyable

@Spyable
public protocol HasDeletedCredentialUseCaseProtocol {
  func execute() -> Bool
}
