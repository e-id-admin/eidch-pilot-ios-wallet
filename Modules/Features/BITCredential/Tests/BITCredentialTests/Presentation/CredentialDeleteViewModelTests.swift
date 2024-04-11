import BITSdJWT
import Factory
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITTestingCore

@MainActor
final class CredentialDeleteViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    deleteCredentialUseCase = DeleteCredentialUseCaseProtocolSpy()
    viewModel = CredentialDeleteViewModel(credential: credential, deleteCredentialUseCase: deleteCredentialUseCase)
  }

  override func tearDown() {
    super.tearDown()
  }

  func test_init() {
    XCTAssertEqual(viewModel.credential, credential)
  }

  func test_confirm() async throws {
    deleteCredentialUseCase.executeClosure = { _ in }
    try await viewModel.confirm()
    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
  }

  func test_confirm_failure() async throws {
    deleteCredentialUseCase.executeThrowableError = TestingError.error
    do {
      try await viewModel.confirm()
    } catch {
      XCTAssertTrue(deleteCredentialUseCase.executeCalled)
      XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential: Credential = .Mock.sample
  private var viewModel: CredentialDeleteViewModel!
  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocolSpy!
  // swiftlint:enable all

}
