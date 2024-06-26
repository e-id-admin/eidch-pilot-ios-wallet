import BITCore
import BITDataStore
import Factory
import XCTest

@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class CredentialActivityRepositoryTests: XCTestCase {

  // MARK: Internal

  override class func setUp() {
    Container.shared.dataStore.register { InMemoryCoreDataStore(containerName: "pilotWallet") }
  }

  override func setUp() {
    repository = CoreDataCredentialRepository()
  }

  func testGetAllActivities_success() async throws {
    try Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample

    let credential = try await repository.create(credential: mockSample)
    let receiveActivity = try await repository.addActivity(.Mock.sampleReceive, to: credential)
    let presentationActivity = try await repository.addActivity(.Mock.samplePresentation, to: credential)

    let activities = try await repository.getAllActivities(for: credential)

    XCTAssertEqual(activities.count, 2)
    XCTAssertTrue(activities.contains(receiveActivity))
    XCTAssertTrue(activities.contains(presentationActivity))

    try Container.shared.dataStore().removeStores()
  }

  func testAddActivities_success() async throws {
    try Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample

    let credential = try await repository.create(credential: mockSample)
    let activity = try await repository.addActivity(.Mock.sampleReceive, to: credential)

    XCTAssertEqual(activity, .Mock.sampleReceive)

    try Container.shared.dataStore().removeStores()
  }

  func testGetLastActivities_success() async throws {
    try Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample
    let mockOffset = 2

    let credential = try await repository.create(credential: mockSample)
    try await repository.addActivity(.Mock.sampleReceive, to: credential)
    try await repository.addActivity(.Mock.samplePresentation, to: credential)
    let activities = try await repository.getLastActivities(for: mockSample, count: mockOffset)

    XCTAssertEqual(activities.count, mockOffset)

    try Container.shared.dataStore().removeStores()
  }

  func testGetLastActivitiesWithTooBigOffset() async throws {
    try Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample
    let mockOffset = 10

    let credential = try await repository.create(credential: mockSample)
    try await repository.addActivity(.Mock.sampleReceive, to: credential)
    try await repository.addActivity(.Mock.samplePresentation, to: credential)
    let activities = try await repository.getLastActivities(for: mockSample, count: mockOffset)

    XCTAssertEqual(activities.count, 2)

    try Container.shared.dataStore().removeStores()
  }

  func testGetLastActivitiesWithSmallerOffset() async throws {
    try Container.shared.dataStore().loadStores()
    let mockSample = Credential.Mock.sample
    let mockOffset = 2

    let credential = try await repository.create(credential: mockSample)
    try await repository.addActivity(.Mock.sampleReceive, to: credential)
    let activities = try await repository.getLastActivities(for: mockSample, count: mockOffset)

    XCTAssertEqual(activities.count, 1)

    try Container.shared.dataStore().removeStores()
  }

  // MARK: Private

  // swiftlint:disable implicitly_unwrapped_optional
  private var repository: (CredentialActivityRepositoryProtocol & CredentialRepositoryProtocol)!
  // swiftlint:enable implicitly_unwrapped_optional
}
