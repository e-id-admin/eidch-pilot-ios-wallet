import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCrypto
@testable import BITLocalAuthentication
@testable import BITTestingCore

// MARK: - ValidateBiometricUseCaseTests

final class PinCodeManagerTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyEncrypter = EncryptableSpy()
    spyPepperRepository = PepperRepositoryProtocolSpy()
    pinCodeManager = PinCodeManager(
      pinCodeSize: Self.pinCodeSize,
      encrypter: spyEncrypter,
      encrypterLength: Self.encrypterLength,
      pepperKeyDerivationAlgorithm: Self.keyDerivationAlgorithm,
      pepperRepository: spyPepperRepository)
  }

  func testValidateRegistrationSuccess() throws {
    try pinCodeManager.validateRegistration("123456")
  }

  func testValidateLoginSuccess() throws {
    try pinCodeManager.validateLogin("123456")
  }

  func testValidateLoginSuccess_shortPin() throws {
    try pinCodeManager.validateLogin("12")
  }

  func testValidateLoginSuccess_specialCharsPinCode() throws {
    try pinCodeManager.validateLogin("aA#$_0")
  }

  func testValidateLoginSuccess_longPinCode() throws {
    try pinCodeManager.validateLogin("12345678901234567890")
  }

  func testValidateRegistrationError_pinEmpty() throws {
    do {
      try pinCodeManager.validateRegistration("")
      XCTFail("Should fail instead...")
    } catch AuthError.pinCodeIsEmpty { }
    catch {
      XCTFail("Unexpected error type")
    }
  }

  func testValidateLoginError_pinEmpty() throws {
    do {
      try pinCodeManager.validateLogin("")
      XCTFail("Should fail instead...")
    } catch AuthError.pinCodeIsEmpty { }
    catch {
      XCTFail("Unexpected error type")
    }
  }

  func testValidateRegistrationError_pinTooShort() throws {
    do {
      try pinCodeManager.validateRegistration("12345")
      XCTFail("Should fail instead...")
    } catch AuthError.pinCodeIsToShort { }
    catch {
      XCTFail("Unexpected error type")
    }
  }

  func testEncrypt() throws {
    let pinCode: PinCode = "123456"
    guard let pinCodeData = pinCode.data(using: .utf8) else { fatalError("Data conversion") }
    let mockPepperKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    let mockInitialVector: Data = .init()
    let mockPinCodeEncrypted: Data = .init()
    spyPepperRepository.getPepperKeyReturnValue = mockPepperKey
    spyPepperRepository.getPepperInitialVectorReturnValue = mockInitialVector
    spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReturnValue = mockPinCodeEncrypted

    let pinCodeEncrypted = try pinCodeManager.encrypt(pinCode)
    XCTAssertEqual(mockPinCodeEncrypted, pinCodeEncrypted)
    XCTAssertTrue(spyPepperRepository.getPepperKeyCalled)
    XCTAssertTrue(spyPepperRepository.getPepperInitialVectorCalled)
    XCTAssertTrue(spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorCalled)
    XCTAssertFalse(spyEncrypter.encryptWithSymmetricKeyInitialVectorCalled)

    XCTAssertEqual(pinCodeData, spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReceivedArguments?.data)
    XCTAssertEqual(mockPepperKey, spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReceivedArguments?.privateKey)
    XCTAssertEqual(Self.encrypterLength, spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReceivedArguments?.length)
    XCTAssertEqual(Self.keyDerivationAlgorithm, spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReceivedArguments?.derivationAlgorithm)
    XCTAssertEqual(mockInitialVector, spyEncrypter.encryptWithAsymmetricKeyLengthDerivationAlgorithmInitialVectorReceivedArguments?.initialVector)
  }

  // MARK: Private

  private static let pinCodeSize = 6
  private static let encrypterLength = 32
  private static let keyDerivationAlgorithm = SecKeyAlgorithm.ecdhKeyExchangeStandardX963SHA256

  // swiftlint:disable all
  private var spyEncrypter: EncryptableSpy!
  private var spyPepperRepository: PepperRepositoryProtocolSpy!
  private var pinCodeManager: PinCodeManagerProtocol!
  // swiftlint:enable all
}
