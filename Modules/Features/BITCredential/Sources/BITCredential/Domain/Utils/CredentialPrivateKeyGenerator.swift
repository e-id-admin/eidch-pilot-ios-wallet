import BITAppAuth
import BITLocalAuthentication
import BITVault
import Factory
import Foundation

// MARK: - CredentialJWTGenerator

struct CredentialPrivateKeyGenerator: CredentialKeyPairGeneratorProtocol {

  // MARK: Lifecycle

  init(
    keyManager: KeyManagerProtocol = Container.shared.keyManager(),
    vaultAccessControlFlags: SecAccessControlCreateFlags = Container.shared.vaultAccessControlFlags(),
    vaultProtection: CFString = Container.shared.vaultProtection(),
    vaultOptions: VaultOption = Container.shared.vaultOptions(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.keyManager = keyManager
    self.vaultAccessControlFlags = vaultAccessControlFlags
    self.vaultProtection = vaultProtection
    self.vaultOptions = vaultOptions
    self.context = context
  }

  // MARK: Internal

  func generate(identifier: UUID, algorithm: String) throws -> SecKey {
    let query = try QueryBuilder()
      .setAccessControlFlags(vaultAccessControlFlags)
      .setProtection(vaultProtection)
      .setContext(context)
      .build()

    return try keyManager.generateKeyPair(
      withIdentifier: identifier.uuidString,
      algorithm: VaultAlgorithm(fromSignatureAlgorithm: algorithm),
      options: vaultOptions,
      query: query)
  }

  // MARK: Private

  private let keyManager: KeyManagerProtocol
  private let vaultAccessControlFlags: SecAccessControlCreateFlags
  private let vaultProtection: CFString
  private let vaultOptions: VaultOption
  private let context: LAContextProtocol
}
