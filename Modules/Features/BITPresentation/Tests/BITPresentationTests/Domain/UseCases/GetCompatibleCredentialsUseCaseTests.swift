import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITTestingCore

final class GetCompatibleCredentialsUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repositorySpy = CredentialRepositoryProtocolSpy()
    useCase = GetCompatibleCredentialsUseCase(repository: repositorySpy)
  }

  func testExecute_success() async throws {
    let mockRequestObject: RequestObject = .Mock.sample
    let mockCredentials: [Credential] = [.Mock.sample, .Mock.sample]
    repositorySpy.getAllReturnValue = mockCredentials
    XCTAssertTrue(mockCredentials.count > 1, "relevant only if there is compatible / no compatible credentials")

    let compatibleCredentials = try await useCase.execute(requestObject: mockRequestObject)

    guard let firstCompatibleCredential = compatibleCredentials.first else { fatalError("No compatible credentials") }
    XCTAssertFalse(firstCompatibleCredential.fields.isEmpty)
    XCTAssertEqual(mockRequestObject.presentationDefinition.inputDescriptors.first?.constraints.fields.count, firstCompatibleCredential.fields.count)

    XCTAssertTrue(repositorySpy.getAllCalled)
    XCTAssertEqual(1, repositorySpy.getAllCallsCount)
  }

  func testExecute_failure() async throws {
    repositorySpy.getAllThrowableError = TestingError.error
    do {
      _ = try await useCase.execute(requestObject: .Mock.sample)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_requestFieldsEmpty() async throws {
    do {
      _ = try await useCase.execute(requestObject: .Mock.sampleWithoutFields)

      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.invalidRequestObject {
      XCTAssertFalse(repositorySpy.getAllCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_credentialsListEmpty() async throws {
    repositorySpy.getAllReturnValue = []
    do {
      _ = try await useCase.execute(requestObject: .Mock.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_noFirstRawCredential() async throws {
    repositorySpy.getAllReturnValue = [.Mock.sampleWithoutRawCredential]
    do {
      _ = try await useCase.execute(requestObject: .Mock.sample)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_noCompatibleCredentials() async throws {
    repositorySpy.getAllReturnValue = [.Mock.sample]
    do {
      _ = try await useCase.execute(requestObject: .Mock.sampleDiploma)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testExecute_oneRequestFieldsNotMatching() async throws {
    repositorySpy.getAllReturnValue = [.Mock.sample]
    do {
      _ = try await useCase.execute(requestObject: .Mock.sampleMultipassExtraField)
      XCTFail("Should have thrown an exception")
    } catch CompatibleCredentialsError.noCompatibleCredentials {
      XCTAssertTrue(repositorySpy.getAllCalled)
      XCTAssertEqual(1, repositorySpy.getAllCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private var useCase = GetCompatibleCredentialsUseCase()
  private var repositorySpy = CredentialRepositoryProtocolSpy()
}
