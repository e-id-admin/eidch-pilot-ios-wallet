import BITAppAuth
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialPrivateKeyGenerator: CredentialPrivateKeyGeneratorProtocol {

  // MARK: Lifecycle

  init(
    vault: VaultProtocol = Container.shared.vault(),
    vaultAccessControlFlags: SecAccessControlCreateFlags = Container.shared.vaultAccessControlFlags(),
    vaultProtection: CFString = Container.shared.vaultProtection(),
    vaultOptions: VaultOption = Container.shared.vaultOptions(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.vault = vault
    self.vaultAccessControlFlags = vaultAccessControlFlags
    self.vaultProtection = vaultProtection
    self.vaultOptions = vaultOptions
    self.context = context
  }

  // MARK: Internal

  func generate(identifier: UUID, algorithm: String) throws -> SecKey {
    try vault.generatePrivateKey(
      withIdentifier: identifier.uuidString,
      algorithm: VaultAlgorithm(fromSignatureAlgorithm: algorithm),
      accessControlFlags: vaultAccessControlFlags,
      protection: vaultProtection,
      options: vaultOptions,
      context: context)
  }

  // MARK: Private

  private let vault: VaultProtocol
  private let vaultAccessControlFlags: SecAccessControlCreateFlags
  private let vaultProtection: CFString
  private let vaultOptions: VaultOption
  private let context: LAContextProtocol
}
