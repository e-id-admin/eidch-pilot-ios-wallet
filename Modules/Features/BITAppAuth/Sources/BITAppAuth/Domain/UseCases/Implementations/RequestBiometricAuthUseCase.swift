import BITLocalAuthentication
import Factory
import Foundation

public struct RequestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocol {

  public func execute(reason: String, context: LAContextProtocol) async throws {
    do {
      guard try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) else {
        throw AuthError.biometricPolicyEvaluationFailed
      }
    } catch {
      throw error
    }
  }

}
