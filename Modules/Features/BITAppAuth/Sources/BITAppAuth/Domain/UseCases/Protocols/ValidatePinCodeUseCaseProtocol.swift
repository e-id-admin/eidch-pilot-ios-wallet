import Foundation
import Spyable

@Spyable
public protocol ValidatePinCodeUseCaseProtocol {
  func execute(from pinCode: PinCode) throws
}
