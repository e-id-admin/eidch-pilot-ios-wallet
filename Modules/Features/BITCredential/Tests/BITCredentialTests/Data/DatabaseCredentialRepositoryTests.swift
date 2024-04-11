import BITCore
import BITDataStore
import Factory
import XCTest
@testable import BITCredential
@testable import BITCredentialMocks

final class DatabaseCredentialRepositoryTests: XCTestCase {

  // MARK: Internal

  override class func setUp() {
    Container.shared.dataStore.register { InMemoryCoreDataStore(containerName: "pilotWallet") }
  }

  override func setUp() {
    repository = CoreDataCredentialRepository()
  }

  // MARK: - Metadata

  func testCreateCredentialSuccess() async throws {
    try await Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample
    let credential = try await repository.create(credential: mockSample)

    XCTAssertEqual(credential, mockSample)
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var repository: CredentialRepositoryProtocol!
  // swiftlint:enable implicitly_unwrapped_optional
}
