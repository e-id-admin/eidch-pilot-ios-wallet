import BITLocalAuthentication
import Foundation

extension Vault {

  // MARK: Public

  public func double(forKey key: String) -> Double? {
    getSecret(forKey: key)
  }

  public func int(forKey key: String) -> Int? {
    getSecret(forKey: key)
  }

  /// - Note: An existing value will try to be deleted and recreated with the new value.
  public func saveSecret(_ value: Any?, forKey key: String) throws {
    try deleteSecret(for: key)

    let data = withUnsafeBytes(of: value) { Data($0) }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: data,
    ]

    try saveSecret(query)
  }

  public func saveSecret(
    _ data: Data,
    for key: String,
    service: String,
    accessControlFlags: SecAccessControlCreateFlags,
    protection: CFString = defaultProtection,
    canOverride: Bool,
    context: LAContextProtocol?,
    reason: String?) throws
  {
    let accessControl = try createAccessControl(accessControlFlags: accessControlFlags, protection: protection)
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: service,
      kSecAttrAccessControl as String: accessControl,
      kSecValueData as String: data,
    ]
    query.setContext(context, reason: reason)

    try saveSecret(query, canOverride: canOverride)
  }

  public func keyExists(
    _ key: String,
    service: String)
    -> Bool
  {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: service,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: false,
      kSecUseAuthenticationContext as String: NoInteractionLAContext(),
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    return status != errSecItemNotFound
  }

  public func getSecret(
    for key: String,
    service: String,
    context: LAContextProtocol?,
    reason: String?) throws
    -> Data
  {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: service,
      kSecReturnData as String: true,
    ]
    query.setContext(context, reason: reason)

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else {
      throw VaultError.secretRetrievalError(reason: "OSStatus error \(status)")
    }
    guard let data = item as? Data else {
      throw VaultError.invalidSecret
    }
    return data
  }

  public func deleteSecret(for key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: false,
    ]

    try deleteSecItem(query)
  }

  public func deleteSecret(for key: String, service: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: service,
      kSecReturnData as String: true,
    ]

    try deleteSecItem(query)
  }

  // MARK: Private

  private func getSecret<T>(forKey key: String) -> T? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else {
      return nil
    }

    return data.withUnsafeBytes { $0.load(as: T.self) }
  }

  private func saveSecret(_ query: [String: Any], canOverride: Bool = true) throws {
    if canOverride {
      try deleteSecItem(query)
    }

    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw VaultError.secretSavingError(reason: "OSStatus error \(status)")
    }
  }

  private func deleteSecItem(_ query: [String: Any]) throws {
    let status = SecItemDelete(query as CFDictionary)
    guard [errSecSuccess, errSecItemNotFound].contains(status) else {
      throw VaultError.secretDeletingError(reason: "OSStatus error \(status)")
    }
  }

}
