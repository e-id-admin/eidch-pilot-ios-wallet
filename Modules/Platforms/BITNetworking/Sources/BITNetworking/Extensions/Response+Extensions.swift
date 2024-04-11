import Foundation
import Moya

extension Response {

  public var isSuccessful: Bool { 200..<300 ~= statusCode }
  public var error: Error { NetworkError(httpStatusCode: statusCode, data: data) }

}
