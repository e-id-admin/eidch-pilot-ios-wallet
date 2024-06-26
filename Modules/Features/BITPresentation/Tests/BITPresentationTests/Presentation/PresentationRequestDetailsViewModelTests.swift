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
    viewModel = PresentationResultViewModel(presentationMetadata: mock, date: mockDate, completed: { self.completed = true })
  }

  // MARK: - Metadata

  func testInitialState() {
    XCTAssertEqual(viewModel.presentationMetadata, .Mock.sample())
    let expectedDateFormatted = "\(dateFormatter.string(from: mockDate)) | \(hourFormatter.string(from: mockDate))"
    XCTAssertEqual(expectedDateFormatted, viewModel.formattedDate)
  }

  func testCompletion() {
    viewModel.completed()
    XCTAssertTrue(completed)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mock: PresentationMetadata = .Mock.sample()
  private let mockDate: Date = .init()
  private let dateFormatter = DateFormatter.longDateFormatter
  private let hourFormatter = DateFormatter.shortHourFormatter
  private var viewModel: PresentationResultViewModel!
  private var completed: Bool = false
  // swiftlint:enable all

}
