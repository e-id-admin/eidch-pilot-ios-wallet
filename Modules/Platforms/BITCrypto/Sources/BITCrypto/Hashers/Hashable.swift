import Foundation
import Spyable

// MARK: - Hashable

@Spyable
public protocol Hashable {

  /// Produce a hash of the data given in parameter
  /// - Parameters:
  ///   - data: the data to hash
  /// - Returns: A hash of the input data
  func hash(_ data: Data) -> Data

  /// Combine the salt and the data given in parameter and produce a hash the result
  /// - Parameters:
  ///   - data: the data to hash
  ///   - salt: the salt to combine with the data
  /// - Returns: A salted hash of the input data
  func salt(_ data: Data, withSalt salt: Data) -> Data

}

extension Hashable {

  public func salt(_ data: Data, withSalt salt: Data) -> Data {
    let saltedData = Data.combine(data, with: salt)
    return hash(saltedData)
  }

}
