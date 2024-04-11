import BITVault
import Factory
import Foundation

struct LoginRepository: LoginRepositoryProtocol {

  // MARK: Lifecycle

  init(vault: VaultProtocol = Container.shared.vault()) {
    self.vault = vault
  }

  // MARK: Internal

  @discardableResult
  func registerAttempt(_ number: Int, kind: AuthMethod) throws -> Int {
    try vault.saveSecret(number, forKey: kind.attemptKey)
    return number
  }

  func getAttempts(kind: AuthMethod) throws -> Int {
    vault.int(forKey: kind.attemptKey) ?? 0
  }

  func resetAttempts(kind: AuthMethod) throws {
    try vault.saveSecret(nil, forKey: kind.attemptKey)
  }

  // MARK: Private

  private let vault: VaultProtocol

}
