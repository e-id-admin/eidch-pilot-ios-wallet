import BITCredential
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks

@MainActor
final class PresentationErrorViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    viewModel = PresentationErrorViewModel(date: mockDate)
  }

  // MARK: - Metadata

  func testInitialState() {
    let expectedDateFormatted = "\(dateFormatter.string(from: mockDate)) | \(hourFormatter.string(from: mockDate))"
    XCTAssertEqual(expectedDateFormatted, viewModel.formattedDate)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockDate: Date = .init()
  private let dateFormatter = DateFormatter.longDateFormatter
  private let hourFormatter = DateFormatter.shortHourFormatter
  private var viewModel: PresentationErrorViewModel!
  // swiftlint:enable all

}
