import Factory
import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks

final class AddActivityToCredentialUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    credentialActivityRepository = CredentialActivityRepositoryProtocolSpy()
    useCase = AddActivityToCredentialUseCase(credentialActivityRepository: credentialActivityRepository)
  }

  func testAddReceiveActivity() async throws {
    let mockActivity: Activity = .Mock.sampleReceive
    credentialActivityRepository.addActivityToReturnValue = mockActivity

    try await useCase.execute(type: .credentialReceived, credential: mockCredential)

    XCTAssertTrue(credentialActivityRepository.addActivityToCalled)
    XCTAssertEqual(mockActivity.type, credentialActivityRepository.addActivityToReceivedInvocations.first?.activity.type)
    XCTAssertEqual(mockCredential, credentialActivityRepository.addActivityToReceivedInvocations.first?.credential)
    XCTAssertNil(credentialActivityRepository.addActivityToReceivedInvocations.first?.activity.verifier)
  }

  func testAddPresentationActivity() async throws {
    let mockActivity: Activity = .Mock.samplePresentation
    credentialActivityRepository.addActivityToReturnValue = mockActivity

    try await useCase.execute(type: .presentationAccepted, credential: mockCredential)
    XCTAssertTrue(credentialActivityRepository.addActivityToCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private let mockCredential: Credential = .Mock.sample
  private var useCase: AddActivityToCredentialUseCase!
  private var credentialActivityRepository: CredentialActivityRepositoryProtocolSpy!
  // swiftlint:enable all
}
