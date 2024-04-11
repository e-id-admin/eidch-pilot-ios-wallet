import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication
@testable import BITTestingCore

// MARK: - RegisterPinCodeUseCaseTests

final class RegisterPinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    spyPinCodeManager = PinCodeManagerProtocolSpy()
    spyPepperService = PepperServiceProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    spyContextManager = ContextManagerProtocolSpy()
    spyContext = LAContextProtocolSpy()
    isBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()

    useCase = RegisterPinCodeUseCase(
      pinCodeManager: spyPinCodeManager,
      pepperService: spyPepperService,
      uniquePassphraseManager: spyUniquePassphraseManager,
      isBiometricUsageAllowedUseCase: isBiometricUsageAllowedUseCase,
      contextManager: spyContextManager,
      context: spyContext)
  }

  func testStandardPinCode() throws {
    try testHappyPath(pinCode: "123456")
  }

  func testSpecialCharsPinCode() throws {
    try testHappyPath(pinCode: "aA#$_0")
  }

  func testLongPinCode() throws {
    try testHappyPath(pinCode: "12345678901234567890")
  }

  func testValidationError() throws {
    let pinCode: PinCode = "1"
    spyPinCodeManager.validateRegistrationThrowableError = AuthError.pinCodeIsToShort
    do {
      try useCase.execute(pinCode: pinCode)
      XCTFail("Should fail instead...")
    } catch AuthError.pinCodeIsToShort {
      XCTAssertTrue(spyPinCodeManager.validateRegistrationCalled)
      XCTAssertFalse(spyPinCodeManager.validateLoginCalled)
      XCTAssertFalse(spyPepperService.generatePepperCalled)
      XCTAssertFalse(spyContextManager.setCredentialContextCalled)
      XCTAssertFalse(spyUniquePassphraseManager.generateCalled)
      XCTAssertFalse(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
      XCTAssertFalse(isBiometricUsageAllowedUseCase.executeCalled)
    } catch {
      XCTFail("Unexpected error type")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var spyPinCodeManager: PinCodeManagerProtocolSpy!
  private var spyPepperService: PepperServiceProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContextManager: ContextManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  private var useCase: RegisterPinCodeUseCase!
  private var isBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocolSpy!

  // swiftlint:enable all

}

extension RegisterPinCodeUseCaseTests {

  private func testHappyPath(pinCode: PinCode) throws {
    let mockPinCodeEncrypted: Data = .init()
    let mockUniquePassphraseData: Data = .init()
    let mockPepperKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    isBiometricUsageAllowedUseCase.executeReturnValue = true
    configureSpy(pinCodeEncrypted: mockPinCodeEncrypted, uniquePassphrase: mockUniquePassphraseData, pepperKey: mockPepperKey)

    try useCase.execute(pinCode: pinCode)
    assertResult(pinCode: pinCode, pinCodeEncrypted: mockPinCodeEncrypted, uniquePassphrase: mockUniquePassphraseData)
  }

  private func configureSpy(pinCodeEncrypted: Data, uniquePassphrase: Data, pepperKey: SecKey) {
    spyPinCodeManager.validateRegistrationClosure = { _ in }
    spyPinCodeManager.encryptReturnValue = pinCodeEncrypted
    spyUniquePassphraseManager.generateReturnValue = uniquePassphrase
    spyPepperService.generatePepperReturnValue = pepperKey
  }

  private func assertResult(pinCode: PinCode, pinCodeEncrypted: Data, uniquePassphrase: Data) {
    XCTAssertTrue(spyPinCodeManager.validateRegistrationCalled)
    XCTAssertFalse(spyPinCodeManager.validateLoginCalled)
    XCTAssertTrue(spyPepperService.generatePepperCalled)
    XCTAssertTrue(spyContextManager.setCredentialContextCalled)
    XCTAssertTrue(spyUniquePassphraseManager.generateCalled)
    XCTAssertTrue(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(pinCode, spyPinCodeManager.validateRegistrationReceivedPinCode)
    XCTAssertEqual(pinCode, spyPinCodeManager.encryptReceivedPinCode)
    XCTAssertEqual(2, spyContextManager.setCredentialContextCallsCount)
    XCTAssertEqual(pinCodeEncrypted, spyContextManager.setCredentialContextReceivedInvocations[0].data)
    XCTAssertEqual(uniquePassphrase, spyContextManager.setCredentialContextReceivedInvocations[1].data)
    XCTAssertEqual(uniquePassphrase, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.biometric, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
    XCTAssertTrue(isBiometricUsageAllowedUseCase.executeCalled)
  }

}
