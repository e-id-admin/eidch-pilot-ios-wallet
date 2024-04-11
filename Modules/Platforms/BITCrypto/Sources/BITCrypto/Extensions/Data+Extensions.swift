import CryptoKit
import Foundation

extension Data {

  var hexString: String {
    map { String(format: "%02hhx", $0) }.joined()
  }

  static func combine(_ data: Data, with anotherData: Data) -> Data {
    data + anotherData
  }

  static func random(length: Int) throws -> Data {
    var randomBytes = [Int8](repeating: 0, count: length)
    let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)

    if status != errSecSuccess {
      throw CryptoError.cannotGenerateRandomBytes
    }

    let data = Data(bytes: randomBytes, count: length)
    return data
  }
}
