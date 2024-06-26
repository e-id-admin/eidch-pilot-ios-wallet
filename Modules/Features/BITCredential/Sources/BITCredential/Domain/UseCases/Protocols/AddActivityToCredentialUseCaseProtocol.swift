import BITActivity
import BITCredentialShared
import Spyable

// MARK: - AddActivityToCredentialUseCaseProtocol

@Spyable
public protocol AddActivityToCredentialUseCaseProtocol {
  func execute(type: ActivityType, credential: Credential, verifier: ActivityVerifier?) async throws
}

extension AddActivityToCredentialUseCaseProtocol {
  public func execute(type: ActivityType, credential: Credential) async throws {
    try await execute(type: type, credential: credential, verifier: nil)
  }
}
