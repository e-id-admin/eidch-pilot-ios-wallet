import Foundation

public typealias PinCode = String

extension PinCode {
  func checkPrerequisites(pinCodeSizeRequired: Int? = nil) throws {
    if isEmpty {
      throw AuthError.pinCodeIsEmpty
    }
    guard let pinCodeSizeRequired else {
      return
    }
    if count < pinCodeSizeRequired {
      throw AuthError.pinCodeIsToShort
    }
  }
}
