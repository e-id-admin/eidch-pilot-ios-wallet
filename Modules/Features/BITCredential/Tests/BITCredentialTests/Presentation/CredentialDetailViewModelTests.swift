import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITTestingCore

@MainActor
final class CredentialDetailViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    viewModel = CredentialDetailViewModel(credential, checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCaseSpy)
  }

  func test_init() {
    XCTAssertFalse(viewModel.isPoliceQRCodePresented)
    XCTAssertFalse(viewModel.isDeleteCredentialPresented)
    XCTAssertFalse(viewModel.isActivitiesListPresented)

    XCTAssertEqual(viewModel.credential, credential)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  func test_onAppear() async {
    checkAndUpdateCredentialStatusUseCaseSpy.executeForReturnValue = credential

    await viewModel.onAppear()

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCaseSpy.executeForCalled)
    XCTAssertNotNil(viewModel.credentialBody)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  func test_onRefresh() async {
    checkAndUpdateCredentialStatusUseCaseSpy.executeForReturnValue = credential

    await viewModel.refresh()

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCaseSpy.executeForCalled)
    XCTAssertNotNil(viewModel.credentialBody)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
  }

  // MARK: Private

  // swiftlint:disable all
  private let credential: Credential = .Mock.sample
  private var viewModel: CredentialDetailViewModel!
  private var checkAndUpdateCredentialStatusUseCaseSpy = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
  // swiftlint:enable all

}
