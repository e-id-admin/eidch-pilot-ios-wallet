import BITCredential
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks

@MainActor
final class PresentationResultViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    completed = false
    viewModel = PresentationResultViewModel(presentationMetadata: mock, completed: { self.completed = true })
  }

  // MARK: - Metadata

  func testInitialState() {
    XCTAssertEqual(viewModel.presentationMetadata, .Mock.sample())
    XCTAssertEqual(viewModel.date, DateFormatter.presentationResult.string(from: Date()))
  }

  func completion() {
    viewModel.completed()
    XCTAssertTrue(completed)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mock: PresentationMetadata = .Mock.sample()

  private var viewModel: PresentationResultViewModel!
  private var completed: Bool = false
  // swiftlint:enable all

}
