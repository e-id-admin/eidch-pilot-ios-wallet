import BITCore
import Foundation
import Spyable
import XCTest

@testable import BITAppAuth
@testable import BITLocalAuthentication

final class ValidatePinCodeUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    spyGetUniquePassphraseUseCase = GetUniquePassphraseUseCaseProtocolSpy()
    spyIsBiometricInvalidatedUseCase = IsBiometricInvalidatedUseCaseProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    spyContext = LAContextProtocolSpy()

    useCase = ValidatePinCodeUseCase(
      getUniquePassphraseUseCase: spyGetUniquePassphraseUseCase,
      isBiometricInvalidatedUseCase: spyIsBiometricInvalidatedUseCase,
      uniquePassphraseManager: spyUniquePassphraseManager,
      context: spyContext)
  }

  func testHappyPath_biometricsValid() throws {
    let mockPinCode = "123456"
    spyGetUniquePassphraseUseCase.executeFromReturnValue = Data()
    spyIsBiometricInvalidatedUseCase.executeReturnValue = false

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(spyGetUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, spyGetUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(spyIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertFalse(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
  }

  func testHappyPath_biometricsInValid() throws {
    let mockPinCode = "123456"
    let mockUniquePassphrase = Data()
    spyGetUniquePassphraseUseCase.executeFromReturnValue = mockUniquePassphrase
    spyIsBiometricInvalidatedUseCase.executeReturnValue = true

    try useCase.execute(from: mockPinCode)
    XCTAssertTrue(spyGetUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPinCode, spyGetUniquePassphraseUseCase.executeFromReceivedPinCode)
    XCTAssertTrue(spyIsBiometricInvalidatedUseCase.executeCalled)
    XCTAssertTrue(spyUniquePassphraseManager.saveUniquePassphraseForContextCalled)
    XCTAssertEqual(mockUniquePassphrase, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(AuthMethod.biometric, spyUniquePassphraseManager.saveUniquePassphraseForContextReceivedArguments?.authMethod)
  }

  func testBiometricsInvalidated() throws {

  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: ValidatePinCodeUseCase!
  private var spyGetUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocolSpy!
  private var spyIsBiometricInvalidatedUseCase: IsBiometricInvalidatedUseCaseProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  // swiftlint:enable all

}
