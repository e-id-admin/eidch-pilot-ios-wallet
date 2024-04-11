import Factory
import XCTest

@testable import BITAppAuth
@testable import BITTestingCore

@MainActor
final class PinCodeChangeFlowViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    updatePinCodeUseCase = UpdatePinCodeUseCaseProtocolSpy()
    getUniquePassphraseUseCase = GetUniquePassphraseUseCaseProtocolSpy()
    viewModel = PinCodeChangeFlowViewModel(updatePinCodeUseCase: updatePinCodeUseCase, getUniquePassphraseUseCase: getUniquePassphraseUseCase)
  }

  func testInitialState() async throws {
    XCTAssertTrue(viewModel.currentPinCode.isEmpty)
    XCTAssertTrue(viewModel.newPinCode.isEmpty)
    XCTAssertTrue(viewModel.newPinCodeConfirmation.isEmpty)
    XCTAssertEqual(viewModel.currentIndex, PinCodeChangeStep.currentPin.rawValue)
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertEqual(viewModel.currentPinCodeState, .normal)
    XCTAssertEqual(viewModel.newPinCodeConfirmationState, .normal)
  }

  func testSetCurrentPin_Success() async throws {
    let mockPin = "123456"
    let mockPassphrase = Data()

    getUniquePassphraseUseCase.executeFromReturnValue = mockPassphrase

    viewModel.currentPinCode = mockPin
    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertEqual(viewModel.currentIndex, PinCodeChangeStep.newPin.rawValue)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPin, getUniquePassphraseUseCase.executeFromReceivedPinCode)
  }

  func testSetCurrentPin_Failure() async throws {
    let mockPin = "123456"

    getUniquePassphraseUseCase.executeFromThrowableError = TestingError.error

    viewModel.currentPinCode = mockPin
    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertEqual(viewModel.currentIndex, PinCodeChangeStep.currentPin.rawValue)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPin, getUniquePassphraseUseCase.executeFromReceivedPinCode)
  }

  func testSetNewPinConfirmation_Success() async throws {
    let mockPin = "123456"
    let mockPassphrase = Data()

    getUniquePassphraseUseCase.executeFromReturnValue = mockPassphrase

    viewModel.currentPinCode = mockPin
    viewModel.newPinCode = mockPin
    viewModel.newPinCodeConfirmation = mockPin
    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertEqual(viewModel.currentIndex, PinCodeChangeStep.newPinConfirmation.rawValue)
    XCTAssertTrue(updatePinCodeUseCase.executeWithAndCalled)
    XCTAssertEqual(mockPassphrase, updatePinCodeUseCase.executeWithAndReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(mockPin, updatePinCodeUseCase.executeWithAndReceivedArguments?.newPinCode)
  }

  func testSetNewPinConfirmation_Failure() async throws {
    let mockPin = "123456"
    let mockPassphrase = Data()

    getUniquePassphraseUseCase.executeFromReturnValue = mockPassphrase
    updatePinCodeUseCase.executeWithAndThrowableError = TestingError.error

    viewModel.currentPinCode = mockPin
    viewModel.newPinCode = mockPin
    viewModel.newPinCodeConfirmation = mockPin
    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertEqual(viewModel.currentIndex, PinCodeChangeStep.newPinConfirmation.rawValue)
    XCTAssertTrue(getUniquePassphraseUseCase.executeFromCalled)
    XCTAssertEqual(mockPin, getUniquePassphraseUseCase.executeFromReceivedPinCode)

    XCTAssertTrue(updatePinCodeUseCase.executeWithAndCalled)
    XCTAssertEqual(mockPassphrase, updatePinCodeUseCase.executeWithAndReceivedArguments?.uniquePassphrase)
    XCTAssertEqual(mockPin, updatePinCodeUseCase.executeWithAndReceivedArguments?.newPinCode)
  }

  // MARK: Private

  //swiftlint:disable all
  private var viewModel: PinCodeChangeFlowViewModel!
  private var updatePinCodeUseCase: UpdatePinCodeUseCaseProtocolSpy!
  private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocolSpy!
  //swiftlint:enable all

}
