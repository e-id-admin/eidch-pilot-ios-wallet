import Foundation
import Spyable

@Spyable
public protocol GetCompatibleCredentialsUseCaseProtocol {
  func execute(requestObject: RequestObject) async throws -> [CompatibleCredential]
}
