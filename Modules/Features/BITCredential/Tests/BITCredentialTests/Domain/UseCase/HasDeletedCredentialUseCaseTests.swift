import Spyable
import XCTest

@testable import BITCredential

final class HasDeletedCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()
    useCase = HasDeletedCredentialUseCase(hasDeletedCredentialRepository: hasDeletedCredentialRepository)
  }

  func testHappyPath() {
    hasDeletedCredentialRepository.hasDeletedCredentialReturnValue = mockHasDeletedCredential

    let hasDeletedCredential = useCase.execute()

    XCTAssertEqual(mockHasDeletedCredential, hasDeletedCredential)
    XCTAssertTrue(hasDeletedCredentialRepository.hasDeletedCredentialCalled)
    XCTAssertEqual(hasDeletedCredentialRepository.hasDeletedCredentialCallsCount, 1)
  }

  // MARK: Private

  private var mockHasDeletedCredential = true
  private var useCase = HasDeletedCredentialUseCase()
  private var hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()
}
