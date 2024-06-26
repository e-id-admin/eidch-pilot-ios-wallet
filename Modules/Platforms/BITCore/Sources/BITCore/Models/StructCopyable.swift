import Foundation

// MARK: - StructCopyable

public protocol StructCopyable {
  func copy() -> Self
}

extension StructCopyable {
  public func copy() -> Self {
    let copy = self
    return copy
  }
}
