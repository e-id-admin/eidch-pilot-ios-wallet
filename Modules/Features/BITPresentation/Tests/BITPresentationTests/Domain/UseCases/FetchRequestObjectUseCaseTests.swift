import BITNetworking
import Spyable
import XCTest

@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITTestingCore

final class FetchRequestObjectUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = PresentationRepositoryProtocolSpy()
    useCase = FetchRequestObjectUseCase(repository: repository)
  }

  func testFetchRequestObject_Success() async throws {
    let expectedRequestObjet = RequestObject.Mock.sample
    guard let mockUrl: URL = .init(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromReturnValue = expectedRequestObjet

    let requestObject = try await useCase.execute(mockUrl)

    XCTAssertEqual(expectedRequestObjet, requestObject)
    XCTAssertTrue(repository.fetchRequestObjectFromCalled)
    XCTAssertEqual(1, repository.fetchRequestObjectFromCallsCount)
  }

  func testFetchRequestObject_InvalidUrl_Failure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromThrowableError = NetworkError(status: .hostnameNotFound)

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch is FetchRequestObjectError {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
      XCTAssertEqual(1, repository.fetchRequestObjectFromCallsCount)
    } catch {
      XCTFail("No the expected execution")
    }
  }

  func testFetchRequestObject_Failure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
      XCTAssertEqual(1, repository.fetchRequestObjectFromCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var useCase = FetchRequestObjectUseCase()
  private var repository = PresentationRepositoryProtocolSpy()
}
