import BITCredential
import XCTest

@testable import BITPresentation

final class PresentationRequestBodyTests: XCTestCase {

  // MARK: Internal

  func test_emptyBody() {
    let presentationRequestBody = PresentationRequestBody()
    XCTAssertTrue(presentationRequestBody.asDictionnary().isEmpty)
  }

  func test_fullBody() {
    let presentationRequestBody = PresentationRequestBody(vpToken: vpToken, presentationSubmission: presentationSubmission, error: .clientRejected, errorDescription: "test")
    let dictionary = presentationRequestBody.asDictionnary()
    XCTAssertFalse(dictionary.isEmpty)
    XCTAssertEqual(dictionary.count, 4)
    XCTAssertTrue(dictionary.contains(where: { $0.key == "vp_token" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "presentation_submission" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "error" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "error_description" }))

    XCTAssertEqual(dictionary["vp_token"] as? String, vpToken)
  }

  func test_acceptPresentation() {
    let presentationRequestBody = PresentationRequestBody(vpToken: vpToken, presentationSubmission: presentationSubmission)
    let dictionary = presentationRequestBody.asDictionnary()
    XCTAssertFalse(dictionary.isEmpty)
    XCTAssertEqual(dictionary.count, 2)
    XCTAssertTrue(dictionary.contains(where: { $0.key == "vp_token" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "presentation_submission" }))
    XCTAssertFalse(dictionary.contains(where: { $0.key == "error" }))
    XCTAssertFalse(dictionary.contains(where: { $0.key == "error_description" }))

    XCTAssertEqual(dictionary["vp_token"] as? String, vpToken)
  }

  func test_refusePresentation() {
    let presentationRequestBody = PresentationRequestBody(error: .clientRejected)
    let dictionary = presentationRequestBody.asDictionnary()
    XCTAssertFalse(dictionary.isEmpty)
    XCTAssertEqual(dictionary.count, 1)
    XCTAssertFalse(dictionary.contains(where: { $0.key == "vp_token" }))
    XCTAssertFalse(dictionary.contains(where: { $0.key == "presentation_submission" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "error" }))
    XCTAssertFalse(dictionary.contains(where: { $0.key == "error_description" }))

    XCTAssertEqual(dictionary["error"] as? String, error.rawValue)
  }

  // MARK: Private

  private static let definitionId = UUID().uuidString

  private static let id = UUID().uuidString

  private let vpToken = "vpToken"
  private let presentationSubmission = PresentationRequestBody.PresentationSubmission(id: id, definitionId: definitionId, descriptorMap: [])
  private let error = PresentationRequestBody.ErrorType.clientRejected

}
