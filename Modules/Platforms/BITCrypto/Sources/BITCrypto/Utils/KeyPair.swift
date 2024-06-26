import Foundation

public struct KeyPair {
  public let key1: SecKey
  public let key2: SecKey

  public init(key1: SecKey, key2: SecKey) {
    self.key1 = key1
    self.key2 = key2
  }
}
