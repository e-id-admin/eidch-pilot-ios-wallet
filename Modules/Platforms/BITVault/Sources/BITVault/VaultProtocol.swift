import BITLocalAuthentication
import Foundation
import Spyable

// MARK: - VaultProtocol

@Spyable
public protocol VaultProtocol {

  @discardableResult
  func generatePrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    options: VaultOption,
    context: LAContextProtocol?,
    reason: String?) throws -> SecKey

  func getPrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> SecKey
  func getPublicKey(withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> SecKey
  func getPublicKey(for privateKey: SecKey) throws -> SecKey

  func deletePrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm) throws
  func deleteAllPrivateKeys() throws

  func double(forKey key: String) -> Double?
  func int(forKey key: String) -> Int?
  func saveSecret(_ value: Any?, forKey key: String) throws

  func saveSecret(
    _ data: Data,
    for key: String,
    service: String,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    canOverride: Bool,
    context: LAContextProtocol?,
    reason: String?) throws
  func keyExists(
    _ key: String,
    service: String) -> Bool
  func getSecret(
    for key: String,
    service: String,
    context: LAContextProtocol?,
    reason: String?) throws -> Data

  func deleteSecret(for key: String) throws
  func deleteSecret(for key: String, service: String) throws

  func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data
  func encrypt(data: Data, usingPublicKey key: SecKey, algorithm: VaultAlgorithm) throws -> Data
  func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data
  func decrypt(data: Data, usingPrivateKey key: SecKey, algorithm: VaultAlgorithm) throws -> Data

  func sign(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Data
  func sign(data: Data, usingKey privateKey: SecKey, algorithm: VaultAlgorithm) throws -> Data
  func verify(signature: Data, for data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> Bool
  func verify(signature: Data, for data: Data, usingKey publicKey: SecKey, algorithm: VaultAlgorithm) throws -> Bool

}
