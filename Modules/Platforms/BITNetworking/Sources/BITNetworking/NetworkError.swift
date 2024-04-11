import Foundation

// MARK: - NetworkError

public enum NetworkError: Error, Equatable {

  case noConnection

  // token
  case invalidUser
  case invalidToken
  case expiredToken

  // >= 400
  case badRequest(data: Data?)
  case invalidGrant
  case unauthorized
  case paymentRequired
  case forbidden
  case notFound
  case notAllowed
  case notAcceptable
  case lengthRequired
  case timeout
  case conflict
  case payloadTooLarge
  case uriTooLong
  case unprocessableEntity
  case unsupportedMediaType
  case gone
  case invalidRequest

  // >= 500
  case internalServerError
  case notImplemented
  case badGateway
  case serviceUnavailable
  case gatewayTimeout
  case insufficientStorage
  case networkAuthenticationRequired

  // other
  case hostnameNotFound
  case unknown(message: String?)

  case pinning

  // MARK: Lifecycle

  public init(httpStatusCode: Int, data: Data? = nil) {
    switch httpStatusCode {
    case 400: self = Self.parseBadRequestError(data: data)
    case 401: self = .unauthorized
    case 402: self = .paymentRequired
    case 403: self = .forbidden
    case 404: self = .notFound
    case 405: self = .notAllowed
    case 406: self = .notAcceptable
    case 408: self = .timeout
    case 409: self = .conflict
    case 411: self = .lengthRequired
    case 413: self = .payloadTooLarge
    case 414: self = .uriTooLong
    case 415: self = .unsupportedMediaType
    case 422: self = .unprocessableEntity
    case 410: self = .gone

    case 500: self = .internalServerError
    case 501: self = .notImplemented
    case 502: self = .badGateway
    case 503: self = .serviceUnavailable
    case 504: self = .gatewayTimeout
    case 507: self = .insufficientStorage
    case 511: self = .networkAuthenticationRequired
    default: self = .unknown(message: nil)
    }
  }

  public init(customMessage: String) {
    self = .unknown(message: customMessage)
  }
}

extension NetworkError {

  private enum NetworkErrorBodyValue: String {
    case invalidGrant = "invalid_grant"
  }

  private static let errorMap: [String: NetworkError] = [
    NetworkErrorBodyValue.invalidGrant.rawValue: .invalidGrant,
  ]

  private static func parseBadRequestError(data: Data?) -> NetworkError {
    do {
      guard let data else {
        return .badRequest(data: data)
      }

      let jsonObject = try JSONDecoder().decode([String: String].self, from: data)

      guard let errorValue = jsonObject["error"], let networkError = errorMap[errorValue] else {
        return .badRequest(data: data)
      }

      return networkError
    } catch {
      return .badRequest(data: data)
    }
  }

}

// MARK: LocalizedError

extension NetworkError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .noConnection:
      "No internet connection"

    case .expiredToken,
         .invalidToken,
         .invalidUser,
         .unauthorized:
      "User Auth failed"

    case .badGateway,
         .internalServerError,
         .notImplemented,
         .serviceUnavailable:
      "Server not available"

    case .gatewayTimeout:
      "Timeout"

    case .hostnameNotFound:
      "Hostname could not be found"

    case .pinning: "Certificate Pinning failure"

    default:
      "Unknown failure..."
    }
  }

  public var errorName: String {
    "\(self)"
  }
}
