import Foundation

// MARK: - ValueType

public enum ValueType: String, Codable {
  case boolean
  case string
  case imagePng = "image/png"
  case imageJpg = "image/jpeg"
}

extension ValueType {
  public var isImage: Bool {
    switch self {
    case .imageJpg,
         .imagePng:
      return true
    default:
      return false
    }
  }
}
