import BITCore
import BITDataStore
import BITSdJWT
import BITVault
import Foundation

// MARK: - RawCredential

public struct RawCredential: Identifiable, Codable {

  // MARK: Lifecycle

  public init(
    format: String = SdJWT.format,
    payload: Data,
    privateKeyIdentifier: UUID,
    algorithm: String = VaultAlgorithm.eciesEncryptionStandardVariableIVX963SHA256AESGCM.rawValue,
    createdAt: Date = .init(),
    updatedAt: Date? = nil)
  {
    self.format = format
    self.payload = payload
    self.privateKeyIdentifier = privateKeyIdentifier
    self.algorithm = algorithm
  }

  public init(_ entity: CredentialRawEntity) {
    format = entity.format
    payload = entity.payload
    privateKeyIdentifier = entity.privateKeyIdentifier
    createdAt = entity.createdAt
    updatedAt = entity.updatedAt
    algorithm = entity.algorithm
  }

  // MARK: Public

  public var format: String
  public var payload: Data
  public var privateKeyIdentifier: UUID

  public var createdAt: Date = .init()
  public var updatedAt: Date? = nil
  public var algorithm: String

  public var id: UUID {
    privateKeyIdentifier
  }

}

// MARK: Equatable

extension RawCredential: Equatable {
  public static func == (lhs: RawCredential, rhs: RawCredential) -> Bool {
    lhs.format == rhs.format && lhs.privateKeyIdentifier == rhs.privateKeyIdentifier && lhs.payload == rhs.payload
  }
}

extension [RawCredential] {
  public var sdJWT: RawCredential? {
    first(where: { $0.format == SdJWT.format })
  }

  public var sdJWTPayload: Data? {
    sdJWT?.payload
  }
}
