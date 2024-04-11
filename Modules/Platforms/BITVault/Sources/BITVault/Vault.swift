import BITLocalAuthentication
import Foundation
import OSLog

// MARK: - Vault

/**
  Represents a secure vault for key generation, encryption, decryption, and signing.

  Provides a layer of abstraction over iOS's Secure Enclave and keychain services.

  - Important: The `Vault` shouldn't have to be set in a Singleton to be used, it's designed to be initialized at any point in time to retrieve the data you need.
  - Important: Thomas shared the feedback that we might need a Encryption/Decryption private key and another private key to Sign. We could then have two methods: `generateEncryptionPrivateKey` & `generateSigningPrivateKey`.
 ,
  */
public class Vault: VaultProtocol {

  // MARK: Lifecycle

  /**
   Initializes a `Vault`

   - Important: The `Vault` shouldn't have to be set in a Singleton to be used, it's designed to be initialized at any point in time to retrieve the data you need.
   */
  public init() {}

  // MARK: Public

  public static let defaultAlgorithm: VaultAlgorithm = .eciesEncryptionStandardVariableIVX963SHA256AESGCM
  public static let defaultAccessFlags: SecAccessControlCreateFlags = [.privateKeyUsage, .applicationPassword]
  public static let defaultProtection: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  public static let defaultOptions: VaultOption = [.savePermanently, .secureEnclave]
}
