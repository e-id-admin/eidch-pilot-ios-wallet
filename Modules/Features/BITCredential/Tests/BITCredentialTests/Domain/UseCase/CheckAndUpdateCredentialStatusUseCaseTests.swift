import BITCore
import BITNetworking
import BITSdJWT
import Factory
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITTestingCore

final class CheckAndUpdateCredentialStatusUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = CredentialRepositoryProtocolSpy()
    localRepositorySpy = CredentialRepositoryProtocolSpy()

    validator = StatusCheckValidatorProtocolSpy()

    Container.shared.databaseCredentialRepository.register { self.localRepositorySpy }

    useCase = CheckAndUpdateCredentialStatusUseCase(localRepository: localRepositorySpy, validators: [validator])
  }

  func testCheckCredentialStatus_valid() async throws {
    localRepositorySpy.updateClosure = { credential in credential }
    validator.validateReturnValue = true

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .valid)
    XCTAssertEqual(credential.status, mockCredential.status)

    XCTAssertTrue(localRepositorySpy.updateCalled)
    XCTAssertEqual(localRepositorySpy.updateCallsCount, 1)
  }

  func testCheckCredentialStatus_invalid() async throws {
    let expiredCredential = Credential(rawCredentials: [RawCredential.Mock.sampleWithStatusExpired])

    localRepositorySpy.updateClosure = { credential in credential }
    validator.validateReturnValue = false

    let credential = try await useCase.execute(for: expiredCredential)

    XCTAssertEqual(credential.status, .invalid)

    XCTAssertTrue(localRepositorySpy.updateCalled)
    XCTAssertEqual(localRepositorySpy.updateCallsCount, 1)
  }

  func testCheckCredentialStatus_unknown() async throws {
    var expectedCredential = mockCredential
    expectedCredential.status = .unknown

    localRepositorySpy.updateReturnValue = expectedCredential
    validator.validateThrowableError = TestingError.error

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .unknown)
    XCTAssertEqual(credential.status, expectedCredential.status)

    XCTAssertTrue(localRepositorySpy.updateCalled)
    XCTAssertEqual(localRepositorySpy.updateCallsCount, 1)
  }

  func testCheckCredentialStatus_valid_butFail() async throws {
    var expectedCredential = mockCredential
    expectedCredential.status = .valid

    localRepositorySpy.updateReturnValue = expectedCredential
    validator.validateThrowableError = TestingError.error

    let credential = try await useCase.execute(for: mockCredential)

    XCTAssertEqual(credential.status, .valid)
    XCTAssertEqual(credential.status, expectedCredential.status)

    XCTAssertTrue(localRepositorySpy.updateCalled)
    XCTAssertEqual(localRepositorySpy.updateCallsCount, 1)
  }

  // MARK: Private

  private let mockCredential = Credential(rawCredentials: [RawCredential.Mock.sampleWithStatus])
  private var useCase = CheckAndUpdateCredentialStatusUseCase()
  private var localRepositorySpy = CredentialRepositoryProtocolSpy()
  private var repository = CredentialRepositoryProtocolSpy()
  private var validator = StatusCheckValidatorProtocolSpy()

}
