import BITCore
import BITNetworking
import Moya
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks

final class PresentationRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = PresentationRepository()
    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register {
      { _ in .immediate }
    }
  }

  // MARK: - Metadata

  func testFetchRequestObjetSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let expectedRequestObject = RequestObject.Mock.sample
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, RequestObject.Mock.sampleData)
    }

    let requestObject = try await repository.fetchRequestObject(from: mockUrl)

    XCTAssertEqual(expectedRequestObject.nonce, requestObject.nonce)
    XCTAssertEqual(expectedRequestObject.presentationDefinition, requestObject.presentationDefinition)
  }

  func testFetchRequestObjetFailure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchRequestObject(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  func testSubmitPresentationSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationRequestBody = PresentationRequestBody.Mock.sample()

    try await repository.submitPresentation(from: mockUrl, presentationRequestBody: presentationRequestBody)
  }

  func testSubmitPresentationFailure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationRequestBody = PresentationRequestBody.Mock.sample()

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: presentationRequestBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var repository = PresentationRepository()
}
