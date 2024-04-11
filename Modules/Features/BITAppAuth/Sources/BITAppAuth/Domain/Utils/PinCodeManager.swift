import BITCrypto
import Factory
import Foundation

struct PinCodeManager: PinCodeManagerProtocol {

  // MARK: Lifecycle

  public init(
    pinCodeSize: Int = Container.shared.pinCodeSize(),
    encrypter: Encryptable = Container.shared.encrypter(),
    pepperRepository: PepperRepositoryProtocol = Container.shared.pepperRepository())
  {
    self.pinCodeSize = pinCodeSize
    self.encrypter = encrypter
    self.pepperRepository = pepperRepository
  }

  // MARK: Internal

  func validateRegistration(_ pinCode: PinCode) throws {
    try validateBasics(pinCode)
    guard pinCode.count == pinCodeSize else {
      throw AuthError.pinCodeIsToShort
    }
  }

  func validateLogin(_ pinCode: PinCode) throws {
    try validateBasics(pinCode)
  }

  func encrypt(_ pinCode: PinCode) throws -> Data {
    let pepperKey = try pepperRepository.getPepperKey()
    let initialVector = try pepperRepository.getPepperInitialVector()
    let pinData = try pinCode.asData()

    return try encrypter.encryptWithDerivedKey(
      fromPrivateKey: pepperKey,
      data: pinData,
      initialVector: initialVector)
  }

  // MARK: Private

  private let pinCodeSize: Int
  private let encrypter: Encryptable
  private let pepperRepository: PepperRepositoryProtocol

  private func validateBasics(_ pinCode: PinCode) throws {
    if pinCode.isEmpty {
      throw AuthError.pinCodeIsEmpty
    }
  }

}
