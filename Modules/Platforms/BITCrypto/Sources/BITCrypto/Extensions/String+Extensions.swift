import Foundation

extension String {

  public func asData(encoding: String.Encoding = .utf8) throws -> Data {
    guard let data: Data = data(using: encoding) else {
      throw CryptoError.cannotGenerateData
    }
    return data
  }

}
