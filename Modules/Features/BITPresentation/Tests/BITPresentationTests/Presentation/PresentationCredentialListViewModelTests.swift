import XCTest

@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITPresentation
@testable import BITPresentationMocks

@MainActor
final class PresentationCredentialListViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    completed = false
    mockRequestObject = .Mock.sample

    viewModel = PresentationCredentialListViewModel(
      requestObject: mockRequestObject,
      compatibleCredentials: mockCompatibleCredentials,
      completed: { self.completed = true })
  }

  func testInitialState() {
    XCTAssertNotNil(viewModel.requestObject)
    XCTAssertFalse(viewModel.compatibleCredentials.isEmpty)
    XCTAssertFalse(viewModel.isMetadataPresented)
    XCTAssertFalse(completed)
    XCTAssertNil(viewModel.selectedCredential)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
  }

  func testClose() async throws {
    await viewModel.send(event: .close)
    XCTAssertTrue(completed)
  }

  func testCancelState() async throws {
    await viewModel.send(event: .cancel)
    XCTAssertTrue(completed)
  }

  func testCredentialSelection() async throws {
    let credential: CompatibleCredential = .Mock.BIT
    await viewModel.send(event: .didSelectCredential(credential))
    XCTAssertTrue(viewModel.isMetadataPresented)
    XCTAssertEqual(viewModel.selectedCredential, credential)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: PresentationCredentialListViewModel!
  private var completed: Bool = false

  private var mockRequestObject: RequestObject!
  private let mockCompatibleCredentials = [CompatibleCredential(credential: .Mock.sample, fields: [])]
  // swiftlint:enable all
}
