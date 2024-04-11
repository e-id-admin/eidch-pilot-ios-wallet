import Foundation
import Spyable

@Spyable
public protocol ValidateBiometricUseCaseProtocol {
  func execute() async throws
}
