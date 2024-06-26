import BITSdJWT
import Factory
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITTestingCore

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
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertTrue(viewModel.isHomePresented)
    XCTAssertEqual(viewModel.credential, credential)
  }

  func test_confirm() async throws {
    deleteCredentialUseCase.executeClosure = { _ in }
    try await viewModel.confirm()
    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
    XCTAssertTrue(viewModel.isHomePresented)
    XCTAssertTrue(viewModel.isPresented)
  }

  func test_confirm_failure() async throws {
    deleteCredentialUseCase.executeThrowableError = TestingError.error
    do {
      try await viewModel.confirm()
    } catch {
      XCTAssertTrue(deleteCredentialUseCase.executeCalled)
      XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
      XCTAssertTrue(viewModel.isHomePresented)
      XCTAssertTrue(viewModel.isPresented)
    }
  }

  func test_close() {
    viewModel.close()
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertTrue(viewModel.isHomePresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential: Credential = .Mock.sample
  private var viewModel: CredentialDeleteViewModel!
  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocolSpy!
  // swiftlint:enable all

}
