import BITLocalAuthentication
import Foundation

///
/// Extensions to give a default 'nil' value to every nullable parameters of the Vault functions
///

extension VaultProtocol {

  @discardableResult
  public func generatePrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    options: VaultOption,
    context: LAContextProtocol?) throws
    -> SecKey
  {
    try generatePrivateKey(
      withIdentifier: identifier,
      algorithm: algorithm,
      accessControlFlags: accessControlFlags,
      protection: protection,
      options: options,
      context: context,
      reason: nil)
  }

  @discardableResult
  public func generatePrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    options: VaultOption) throws
    -> SecKey
  {
    try generatePrivateKey(
      withIdentifier: identifier,
      algorithm: algorithm,
      accessControlFlags: accessControlFlags,
      protection: protection,
      options: options,
      context: nil,
      reason: nil)
  }

  public func getPrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm,
    context: LAContextProtocol?) throws
    -> SecKey
  {
    try getPrivateKey(withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  public func getPrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm) throws
    -> SecKey
  {
    try getPrivateKey(withIdentifier: identifier, algorithm: algorithm, context: nil)
  }

  public func getPublicKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm,
    context: LAContextProtocol?) throws
    -> SecKey
  {
    try getPublicKey(withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  public func getPublicKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm) throws
    -> SecKey
  {
    try getPublicKey(withIdentifier: identifier, algorithm: algorithm, context: nil, reason: nil)
  }

}

extension VaultProtocol {

  public func saveSecret(
    _ data: Data,
    for key: String,
    service: String,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    canOverride: Bool,
    context: LAContextProtocol?) throws
  {
    try saveSecret(data, for: key, service: service, accessControlFlags: accessControlFlags, protection: protection, canOverride: canOverride, context: context, reason: nil)
  }

  public func saveSecret(
    _ data: Data,
    for key: String,
    service: String,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString,
    canOverride: Bool) throws
  {
    try saveSecret(data, for: key, service: service, accessControlFlags: accessControlFlags, protection: protection, canOverride: canOverride, context: nil, reason: nil)
  }

  public func getSecret(
    for key: String,
    service: String,
    context: LAContextProtocol?) throws
    -> Data
  {
    try getSecret(for: key, service: service, context: context, reason: nil)
  }

  public func getSecret(
    for key: String,
    service: String) throws
    -> Data
  {
    try getSecret(for: key, service: service, context: nil, reason: nil)
  }

}

extension VaultProtocol {

  // MARK: Public

  public func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?) throws -> Data {
    try encrypt(data: data, withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  public func encrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm) throws -> Data {
    try encrypt(data: data, withIdentifier: identifier, algorithm: algorithm, context: nil, reason: nil)
  }

  // MARK: Internal

  func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?) throws -> Data {
    try decrypt(data: data, withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  func decrypt(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm) throws -> Data {
    try decrypt(data: data, withIdentifier: identifier, algorithm: algorithm, context: nil, reason: nil)
  }

}

extension VaultProtocol {

  public func sign(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?) throws -> Data {
    try sign(data: data, withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  public func sign(data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm) throws -> Data {
    try sign(data: data, withIdentifier: identifier, algorithm: algorithm, context: nil, reason: nil)
  }

  public func verify(signature: Data, for data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm, context: LAContextProtocol?) throws -> Bool {
    try verify(signature: signature, for: data, withIdentifier: identifier, algorithm: algorithm, context: context, reason: nil)
  }

  public func verify(signature: Data, for data: Data, withIdentifier identifier: String, algorithm: VaultAlgorithm) throws -> Bool {
    try verify(signature: signature, for: data, withIdentifier: identifier, algorithm: algorithm, context: nil, reason: nil)
  }
}
