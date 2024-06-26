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
final class CredentialOfferViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    viewModel = CredentialOfferViewModel(
      credential: credential,
      isPresented: .init(get: { self.isPresented }, set: { value in self.isPresented = value }))
  }

  func test_init() {
    XCTAssertEqual(credential, viewModel.credential)
    XCTAssertTrue(viewModel.isPresented)
    XCTAssertFalse(viewModel.isConfirmationScreenPresented)
  }

  func test_refuse() {
    viewModel.refuse()

    XCTAssertTrue(viewModel.isPresented)
    XCTAssertTrue(viewModel.isConfirmationScreenPresented)
  }

  func test_accept() {
    viewModel.accept()
    XCTAssertFalse(viewModel.isPresented)
    XCTAssertFalse(viewModel.isConfirmationScreenPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential: Credential = .Mock.sample
  private var isPresented: Bool = true
  private var viewModel: CredentialOfferViewModel!
  // swiftlint:enable all

}
