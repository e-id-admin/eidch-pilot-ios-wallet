import Foundation
import Spyable

@Spyable
public protocol PinCodeManagerProtocol {
  func validateRegistration(_ pinCode: PinCode) throws
  func validateLogin(_ pinCode: PinCode) throws
  func encrypt(_ pinCode: PinCode) throws -> Data
}
