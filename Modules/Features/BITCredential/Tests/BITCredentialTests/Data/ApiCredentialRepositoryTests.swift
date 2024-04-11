import BITCore
import BITNetworking
import BITSdJWT
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITSdJWTMocks

// MARK: - ApiCredentialRepositoryTests

final class ApiCredentialRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = ApiCredentialRepository()

    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register {
      { _ in .immediate }
    }
  }

  // MARK: - Metadata

  func testFetchMetadataSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let expectedMetadata: CredentialMetadata = .Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, CredentialMetadata.Mock.sampleData)
    }

    let metadata = try await repository.fetchMetadata(from: mockUrl)

    XCTAssertEqual(expectedMetadata.credentialEndpoint, metadata.credentialEndpoint)
    XCTAssertEqual(expectedMetadata.credentialIssuer, metadata.credentialIssuer)
    XCTAssertEqual(expectedMetadata.credentialsSupported.count, metadata.credentialsSupported.count)
    XCTAssertEqual(expectedMetadata.display.count, metadata.display.count)
    XCTAssertEqual(expectedMetadata.display.first, metadata.preferredDisplay)
  }

  func testFetchMetadataNetworkError() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchMetadata(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

  // MARK: - OpenIdConfiguration

  func testFetchOpenIdConfigurationSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let expectedConfiguration: OpenIdConfiguration = .Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, OpenIdConfiguration.Mock.sampleData)
    }

    let configuration = try await repository.fetchOpenIdConfiguration(from: mockUrl)

    XCTAssertEqual(expectedConfiguration, configuration)
  }

  func testFetchOpenIdConfigurationNetworkError() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchOpenIdConfiguration(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

  // MARK: - AccessToken

  func testFetchAccessToken_success() async throws {
    guard let mockURL: URL = .init(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"
    let expectedAccessToken: AccessToken = .Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, AccessToken.Mock.sampleData)
    }

    let accessToken = try await repository.fetchAccessToken(from: mockURL, preAuthorizedCode: preAuthorizedCode)

    XCTAssertEqual(expectedAccessToken.accessToken, accessToken.accessToken)
    XCTAssertEqual(expectedAccessToken.nounce, accessToken.nounce)
  }

  func testFetchAccessToken_invalidGrant() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    let mockInvalidGandError = ["error": "invalid_grant"]
    let mockInvalidGandErrorData = try JSONEncoder().encode(mockInvalidGandError)
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(400, mockInvalidGandErrorData)
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch NetworkError.invalidGrant {
      /* Expected error received ! */
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testFetchAccessToken_unknownBadRequest() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    let mockInvalidGandError = ["error": "something_unknown"]
    let mockInvalidGandErrorData = try JSONEncoder().encode(mockInvalidGandError)
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(400, mockInvalidGandErrorData)
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch NetworkError.invalidGrant {
      XCTFail("Not the expected error")
    } catch {
      /* Expected error received ! */
    }
  }

  func testFetchAccessToken_failure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let preAuthorizedCode = "code"

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchAccessToken(from: mockUrl, preAuthorizedCode: preAuthorizedCode)
      XCTFail("Should have thrown an error")
    } catch NetworkError.internalServerError {
      /* The expected error */
    } catch {
      XCTFail("Not the expected error")
    }
  }

  // MARK: - fetchOpenIdConfiguration

  func testFetchOpenIdConfiguration_success() async throws {
    guard let mockURL: URL = .init(string: strURL) else {
      fatalError("url building")
    }

    let expectedConfiguration: OpenIdConfiguration = .Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, OpenIdConfiguration.Mock.sampleData)
    }

    let configuration = try await repository.fetchOpenIdConfiguration(from: mockURL)

    XCTAssertEqual(configuration.issuerEndpoint, expectedConfiguration.issuerEndpoint)
    XCTAssertEqual(configuration.tokenEndpoint, expectedConfiguration.tokenEndpoint)
  }

  func testFetchOpenIdConfiguration_failure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchOpenIdConfiguration(from: mockUrl)
      XCTFail("Should have thrown an error")
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

  // MARK: - Credential

  func testFetchCredential_success() async throws {
    guard let mockURL: URL = .init(string: strURL) else { fatalError("url building") }

    let accessToken = AccessToken.Mock.sample
    let credentialRequestBody = CredentialRequestBody.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, SdJWT.Mock.sampleData)
    }
    let expectedCredential: SdJWT = .Mock.sample

    let credentialResponse = try await repository.fetchCredential(from: mockURL, credentialRequestBody: credentialRequestBody, acccessToken: accessToken)
    XCTAssertEqual(credentialResponse.rawCredential, expectedCredential.raw)
    XCTAssertNotNil(credentialResponse.format)
    XCTAssertNotNil(credentialResponse.rawJWT)
    guard let sdJWT = SdJWT(from: credentialResponse.rawCredential) else {
      XCTFail("The credential received can't be converted in a SD-JWT")
      return
    }
    XCTAssertEqual(sdJWT.claims.count, expectedCredential.claims.count)
  }

  func testFetchCredential_failure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }

    let accessToken = AccessToken.Mock.sample
    let credentialRequestBody = CredentialRequestBody.Mock.sample

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchCredential(from: mockUrl, credentialRequestBody: credentialRequestBody, acccessToken: accessToken)
      XCTFail("Should have thrown an error")
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

  // MARK: - Status

  func testCheckStatus_success() async throws {
    guard let mockURL: URL = .init(string: strURL) else { fatalError("url building") }
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(200, JWT.Mock.validStatusSampleData)
    }
    let expectedJWT: JWT = .Mock.validStatusSample
    let jwt = try await repository.fetchCredentialStatus(from: mockURL)
    XCTAssertEqual(jwt, expectedJWT)
  }

  func testCheckStatus_failure() async throws {
    guard let mockURL: URL = .init(string: strURL) else { fatalError("url building") }

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.fetchCredentialStatus(from: mockURL)
      XCTFail("Should have thrown an error")
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var repository = ApiCredentialRepository()

}
