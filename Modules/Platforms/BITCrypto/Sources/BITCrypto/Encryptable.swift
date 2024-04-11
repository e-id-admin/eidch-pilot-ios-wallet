import Foundation
import Spyable

// MARK: - Encryptable

@Spyable
public protocol Encryptable {
  var algorithm: Algorithm { get }
  func generateRandomBytes(length: Int) throws -> Data
  func hash(data: Data, withSalt salt: Data?) throws -> Data
  func encryptWithDerivedKey(fromPrivateKey privateKey: SecKey, data: Data, initialVector: Data?) throws -> Data
}

extension Encryptable {

  /// Default nil values for optional parameters
  public func encryptWithDerivedKey(fromPrivateKey privateKey: SecKey, data: Data) throws -> Data {
    try encryptWithDerivedKey(fromPrivateKey: privateKey, data: data, initialVector: nil)
  }

}
