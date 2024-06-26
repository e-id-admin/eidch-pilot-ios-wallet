import XCTest

@testable import BITActivity
@testable import BITCredentialShared

final class ActivityCellViewModelTests: XCTestCase {

  // MARK: Internal

  func testFormattedDate() {
    let mockDate = Date()
    let expectedDateFormatted = "\(dateFormatter.string(from: mockDate)) | \(hourFormatter.string(from: mockDate))"
    let mockActivity = Activity(Credential(createdAt: mockDate), activityType: .credentialReceived, verifier: nil)
    let viewModel = ActivityCellViewModel(mockActivity)
    XCTAssertEqual(expectedDateFormatted, viewModel.formattedDate)

  }

  func testVerifierNameWithIssuerDisplay() {
    let mockActivity = Activity(Credential(issuerDisplays: [.init(locale: locale, name: issuer, credentialId: .init(), image: nil)]), activityType: .credentialReceived, verifier: nil)
    let viewModel = ActivityCellViewModel(mockActivity)

    XCTAssertEqual(viewModel.verifierName, issuer)
  }

  func testVerifierNameWithVerifier() {
    let mockActivity = Activity(Credential(issuerDisplays: [.init(locale: locale, name: issuer, credentialId: .init(), image: nil)]), activityType: .credentialReceived, verifier: .init(name: verifier))
    let viewModel = ActivityCellViewModel(mockActivity)

    XCTAssertEqual(viewModel.verifierName, verifier)
  }

  func testVerifierNameWithoutIssuerDisplayOrVerifier() {
    let mockActivity = Activity(Credential(), activityType: .credentialReceived, verifier: nil)
    let viewModel = ActivityCellViewModel(mockActivity)

    XCTAssertEqual(viewModel.verifierName, L10n.globalNotAssigned)
  }

  // MARK: Private

  private let locale: String = "de-CH"
  private let issuer: String = "issuer"
  private let verifier: String = "verifier"
  private let dateFormatter = DateFormatter.longDateFormatter
  private let hourFormatter = DateFormatter.shortHourFormatter
}
