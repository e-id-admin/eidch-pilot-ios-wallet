import BITCore
import BITVault
import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITLocalAuthentication

// MARK: - ValidateBiometricUseCaseTests

final class ValidateBiometricUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    spyRequestBiometricAuthUseCase = RequestBiometricAuthUseCaseProtocolSpy()
    spyUniquePassphraseManager = UniquePassphraseManagerProtocolSpy()
    spyContextManager = ContextManagerProtocolSpy()
    spyContext = LAContextProtocolSpy()
    useCase = ValidateBiometricUseCase(
      requestBiometricAuthUseCase: spyRequestBiometricAuthUseCase,
      uniquePassphraseManager: spyUniquePassphraseManager,
      contextManager: spyContextManager,
      context: spyContext)
  }

  func testHappyPath() async throws {
    let mockUniquePassphraseData: Data = .init()
    spyRequestBiometricAuthUseCase.executeReasonContextClosure = { _, _ in }
    spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextReturnValue = mockUniquePassphraseData
    try await useCase.execute()
    XCTAssertTrue(spyRequestBiometricAuthUseCase.executeReasonContextCalled)
    XCTAssertTrue(spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextCalled)
    XCTAssertTrue(spyContextManager.setCredentialContextCalled)

    XCTAssertEqual(AuthMethod.biometric, spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextReceivedArguments?.authMethod)
    XCTAssertEqual(mockUniquePassphraseData, spyContextManager.setCredentialContextReceivedArguments?.data)

  }

  func testBiometricsUseCaseError() async throws {
    spyRequestBiometricAuthUseCase.executeReasonContextThrowableError = AuthError.biometricPolicyEvaluationFailed
    do {
      try await useCase.execute()
      XCTFail("Should fail instead...")
    } catch AuthError.biometricPolicyEvaluationFailed {
      XCTAssertTrue(spyRequestBiometricAuthUseCase.executeReasonContextCalled)
      XCTAssertFalse(spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextCalled)
      XCTAssertFalse(spyContextManager.setCredentialContextCalled)
    } catch {
      XCTFail("Unexpected error: \(error.localizedDescription)")
    }
  }

  func testWrongBiometrics() async throws {
    spyRequestBiometricAuthUseCase.executeReasonContextClosure = { _, _ in }
    spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextThrowableError = VaultError.secretRetrievalError(reason: "wrong biometrics")
    do {
      try await useCase.execute()
      XCTFail("Should fail instead...")
    } catch VaultError.secretRetrievalError {
      XCTAssertTrue(spyRequestBiometricAuthUseCase.executeReasonContextCalled)
      XCTAssertTrue(spyUniquePassphraseManager.getUniquePassphraseAuthMethodContextCalled)
      XCTAssertFalse(spyContextManager.setCredentialContextCalled)
    } catch {
      XCTFail("Unexpected error: \(error.localizedDescription)")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var spyRequestBiometricAuthUseCase: RequestBiometricAuthUseCaseProtocolSpy!
  private var spyUniquePassphraseManager: UniquePassphraseManagerProtocolSpy!
  private var spyContextManager: ContextManagerProtocolSpy!
  private var spyContext: LAContextProtocolSpy!
  private var useCase: ValidateBiometricUseCase!
  // swiftlint:enable all

}

extension ValidateBiometricUseCaseTests {

  private func configureSpy(uniquePassphrase: Data, requestBiometricError: Error?) {
    if let requestBiometricError {
      spyRequestBiometricAuthUseCase.executeReasonContextThrowableError = requestBiometricError
    } else {
      spyRequestBiometricAuthUseCase.executeReasonContextClosure = { _, _ in }
    }
    spyUniquePassphraseManager.generateReturnValue = uniquePassphrase
  }

}
