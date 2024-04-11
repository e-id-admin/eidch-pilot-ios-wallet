import BITLocalAuthentication
import Foundation

extension Vault {

  /**
   Allows to generate a private key following the given parameters.

    - Parameter identifier: String
    - Parameter algorithm: The encryption algorithm to be used. Default value is `.eciesEncryptionCofactorVariableIVX963SHA256AESGCM`.
    - Parameter accessControlFlags: The access control settings for the vault. Defaults to: `[.privateKeyUsage, .applicationPassword]`.
    - Parameter protection: The protection control settings for the vault. Default is `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`.
    - Parameter options: Provide the possibility to pass some options found in `VaultOption`. defaults to `[.savePermanently, .secureEnclave]`.
    - Parameter canOverride: Remove any existing keys with the same identifier before trying to create the new one
    - Parameter context: Give the possibility to pass a custom LAContext to handle the application password nicely.

    - Returns SecKey: a private key
    */
  public func generatePrivateKey(
    withIdentifier identifier: String,
    algorithm: VaultAlgorithm = defaultAlgorithm,
    accessControlFlags: SecAccessControlCreateFlags = defaultAccessFlags,
    protection: CFString = defaultProtection,
    options: VaultOption = defaultOptions,
    context: LAContextProtocol?,
    reason: String?) throws
    -> SecKey
  {
    guard let dataIdentifier = identifier.data(using: .utf8) else { throw VaultError.identifierCannotBeCasted }

    var attributes: [String: Any] = [
      kSecAttrKeyType as String: algorithm.keyType,
      kSecAttrKeySizeInBits as String: algorithm.size,
      kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: options.contains(.savePermanently),
        kSecAttrApplicationTag as String: dataIdentifier,
      ],
    ]

    let accessControl = try createAccessControl(accessControlFlags: accessControlFlags, protection: protection)
    if options.contains(.secureEnclave) && algorithm.canBeUsedForSecureEnclave {
      attributes[kSecAttrTokenID as String] = kSecAttrTokenIDSecureEnclave
      attributes[kSecPrivateKeyAttrs as String] = [
        kSecAttrIsPermanent as String: options.contains(.savePermanently),
        kSecAttrApplicationTag as String: dataIdentifier,
        kSecAttrAccessControl as String: accessControl,
      ]
    }

    attributes.setContext(context, reason: reason)

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
      if let keyGenError = error?.takeRetainedValue() {
        throw VaultError.keyGenerationError(reason: "Key generation failed with error: \(keyGenError)")
      } else {
        throw VaultError.keyGenerationError(reason: "Unknown error during key generation.")
      }
    }

    return privateKey
  }

  public func getPrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> SecKey {
    guard let dataIdentifier = identifier.data(using: .utf8) else { throw VaultError.identifierCannotBeCasted }

    var query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrApplicationTag as String: dataIdentifier,
      kSecAttrKeyType as String: algorithm.keyType,
      kSecReturnRef as String: true,
    ]

    query.setContext(context)

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == errSecSuccess, item != nil else {
      throw VaultError.keyRetrievalError
    }

    // swiftlint:disable force_cast
    // Force cast disabled because we have to cast it this way at this point. a guard doesn't work unfortunately...
    return item as! SecKey
    // swiftlint: enable force_cast
  }

  public func getPublicKey(withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm, context: LAContextProtocol?, reason: String?) throws -> SecKey {
    let privateKey = try getPrivateKey(withIdentifier: identifier, algorithm: algorithm, context: context, reason: reason)
    return try getPublicKey(for: privateKey)
  }

  public func getPublicKey(for privateKey: SecKey) throws -> SecKey {
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw VaultError.publicKeyRetrievalError
    }
    return publicKey
  }

  public func deletePrivateKey(withIdentifier identifier: String, algorithm: VaultAlgorithm = defaultAlgorithm) throws {
    guard let dataIdentifier = identifier.data(using: .utf8) else { throw VaultError.identifierCannotBeCasted }

    let query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrApplicationTag as String: dataIdentifier,
      kSecAttrKeyType as String: algorithm.keyType,
    ]

    let status = SecItemDelete(query as CFDictionary)
    guard [errSecSuccess, errSecItemNotFound].contains(status) else {
      throw VaultError.keyDeletionError
    }
  }

  public func deleteAllPrivateKeys() throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
    ]

    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess else {
      throw VaultError.keyDeletionError
    }
  }

}
