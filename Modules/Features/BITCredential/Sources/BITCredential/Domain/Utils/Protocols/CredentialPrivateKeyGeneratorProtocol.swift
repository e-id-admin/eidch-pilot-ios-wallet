import Foundation
import Spyable

// MARK: - CredentialJWTGeneratorProtocol

@Spyable
protocol CredentialPrivateKeyGeneratorProtocol {
  func generate(identifier: UUID, algorithm: String) throws -> SecKey
}
