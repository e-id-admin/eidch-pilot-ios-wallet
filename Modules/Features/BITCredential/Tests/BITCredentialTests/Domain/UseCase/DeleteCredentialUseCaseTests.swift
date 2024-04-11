import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITTestingCore
@testable import BITVault

final class DeleteCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    vaultSpy = VaultProtocolSpy()
    localRepositorySpy = CredentialRepositoryProtocolSpy()
    hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()

    useCase = DeleteCredentialUseCase(databaseRepository: localRepositorySpy, vault: vaultSpy, hasDeletedCredentialRepository: hasDeletedCredentialRepository)
  }

  func testDeleteCredential_Success() async throws {
    try await useCase.execute(mockCredential)

    XCTAssertTrue(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCalled)
    XCTAssertEqual(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCallsCount, 1)
    XCTAssertEqual(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCallsCount, mockCredential.rawCredentials.count)

    XCTAssertTrue(localRepositorySpy.deleteCalled)
    XCTAssertEqual(localRepositorySpy.deleteCallsCount, 1)

    XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
    XCTAssertEqual(hasDeletedCredentialRepository.setHasDeletedCredentialCallsCount, 1)
  }

  func testDeleteCredential_FailureOnVault() async throws {
    vaultSpy.deletePrivateKeyWithIdentifierAlgorithmThrowableError = TestingError.error

    do {
      try await useCase.execute(mockCredential)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(localRepositorySpy.deleteCalled)
      XCTAssertEqual(localRepositorySpy.deleteCallsCount, 1)

      XCTAssertTrue(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCalled)
      XCTAssertEqual(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCallsCount, 1)

      XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
      XCTAssertEqual(hasDeletedCredentialRepository.setHasDeletedCredentialCallsCount, 1)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testDeleteCredential_FailureOnVaultAlgorithm() async throws {
    guard var rawCredential = mockCredential.rawCredentials.first else {
      fatalError("Failed getting rawcredential")
    }

    rawCredential.algorithm = "fake_algo"
    mockCredential.rawCredentials = [rawCredential]

    do {
      try await useCase.execute(mockCredential)
      XCTFail("Should have thrown an exception")
    } catch {
      XCTAssertEqual(error as? DeleteCredentialError, .invalidAlgorithm)
      XCTAssertTrue(localRepositorySpy.deleteCalled)
      XCTAssertEqual(localRepositorySpy.deleteCallsCount, 1)

      XCTAssertTrue(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
      XCTAssertEqual(hasDeletedCredentialRepository.setHasDeletedCredentialCallsCount, 1)
    }
  }

  func testDeleteCredential_FailureOnRepository() async throws {
    localRepositorySpy.deleteThrowableError = TestingError.error

    do {
      try await useCase.execute(mockCredential)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(localRepositorySpy.deleteCalled)
      XCTAssertEqual(localRepositorySpy.deleteCallsCount, 1)

      XCTAssertTrue(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCalled)
      XCTAssertEqual(vaultSpy.deletePrivateKeyWithIdentifierAlgorithmCallsCount, 1)

      XCTAssertFalse(hasDeletedCredentialRepository.setHasDeletedCredentialCalled)
      XCTAssertEqual(hasDeletedCredentialRepository.setHasDeletedCredentialCallsCount, 0)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  // MARK: Private

  private var mockCredential = Credential.Mock.sample
  private var useCase = DeleteCredentialUseCase()
  private var vaultSpy = VaultProtocolSpy()
  private var localRepositorySpy = CredentialRepositoryProtocolSpy()
  private var hasDeletedCredentialRepository = HasDeletedCredentialRepositoryProtocolSpy()
}
