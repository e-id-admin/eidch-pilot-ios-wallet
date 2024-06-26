import BITCore
import BITSdJWT
import Factory
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

@MainActor
final class CredentialOfferDeclineConfirmationViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    deleteCredentialUseCase = DeleteCredentialUseCaseProtocolSpy()
    onDelete = false

    viewModel = CredentialOfferDeclineConfirmationViewModel(
      credential: credential,
      isPresented: .init(get: { self.isPresented }, set: { value in self.isPresented = value }),
      onDelete: { self.onDelete = true },
      deleteCredentialUseCase: deleteCredentialUseCase)
  }

  func test_init() {
    XCTAssertEqual(credential, viewModel.credential)
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(deleteCredentialUseCase.executeCalled)
  }

  func test_cancel() {
    viewModel.cancel()
    XCTAssertFalse(onDelete)
    XCTAssertFalse(viewModel.isPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(deleteCredentialUseCase.executeCalled)
  }

  func test_delete() async {
    await viewModel.delete()
    XCTAssertFalse(viewModel.isPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(onDelete)

    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential: Credential = .Mock.sample
  private var isPresented: Bool = true
  private var onDelete: Bool = false
  private var viewModel: CredentialOfferDeclineConfirmationViewModel!
  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocolSpy!
  // swiftlint:enable all

}
