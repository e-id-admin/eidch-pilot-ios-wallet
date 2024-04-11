import BITSdJWT
import Factory
import Spyable
import XCTest
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class SaveCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = CredentialRepositoryProtocolSpy()
    Container.shared.databaseCredentialRepository.register { self.repository }
    useCase = SaveCredentialUseCase()
  }

  func testSaveCredentialHappyPath() async throws {
    let metadataWrapper = CredentialMetadataWrapper.Mock.sample
    let mockCredential = Credential.Mock.sample
    let sdJWT = SdJWT.Mock.sample

    repository.createCredentialReturnValue = mockCredential

    let credential = try await useCase.execute(sdJWT: sdJWT, metadataWrapper: metadataWrapper)

    XCTAssertEqual(credential, mockCredential)
    XCTAssertTrue(repository.createCredentialCalled)
    XCTAssertEqual(repository.createCredentialCallsCount, 1)
    XCTAssertFalse(repository.deleteCalled)
    XCTAssertFalse(repository.updateCalled)
    XCTAssertFalse(repository.getIdCalled)
    XCTAssertFalse(repository.fetchMetadataFromCalled)
    XCTAssertFalse(repository.fetchOpenIdConfigurationFromCalled)
    XCTAssertFalse(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
    XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
  }

  func testSaveCredentialFailurePath() async throws {
    let metadataWrapper = CredentialMetadataWrapper.Mock.sample
    repository.createCredentialThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(sdJWT: .Mock.sample, metadataWrapper: metadataWrapper)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repository.createCredentialCalled)
      XCTAssertEqual(repository.createCredentialCallsCount, 1)
      XCTAssertFalse(repository.deleteCalled)
      XCTAssertFalse(repository.updateCalled)
      XCTAssertFalse(repository.getIdCalled)
      XCTAssertFalse(repository.fetchMetadataFromCalled)
      XCTAssertFalse(repository.fetchOpenIdConfigurationFromCalled)
      XCTAssertFalse(repository.fetchAccessTokenFromPreAuthorizedCodeCalled)
      XCTAssertFalse(repository.fetchCredentialFromCredentialRequestBodyAcccessTokenCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private var useCase: SaveCredentialUseCaseProtocol!
  // swiftlint:enable all

}
