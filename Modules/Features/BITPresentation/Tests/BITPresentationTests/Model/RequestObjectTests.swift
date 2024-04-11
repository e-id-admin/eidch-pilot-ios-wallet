import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks

final class RequestObjectTests: XCTestCase {

  func testDecodingRequestObject() throws {
    let mockRequestObjectData = RequestObject.Mock.sampleData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertFalse(mockRequestObject.nonce.isEmpty)
    XCTAssertNotNil(mockRequestObject.clientMetadata)
  }

  func testDecodingRequestObjectWithoutClientMetadata() throws {
    let mockRequestObjectData = RequestObject.Mock.sampleWithoutClientMetadataData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertFalse(mockRequestObject.nonce.isEmpty)
    XCTAssertNil(mockRequestObject.clientMetadata)
  }
}
