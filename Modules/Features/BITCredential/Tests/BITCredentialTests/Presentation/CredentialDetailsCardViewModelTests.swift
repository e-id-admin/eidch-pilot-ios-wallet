import BITSdJWT
import Factory
import Spyable
import XCTest

@testable import BITActivity
@testable import BITActivityMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITTestingCore

@MainActor
final class CredentialDetailsCardViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
    getLastCredentialActivitiesUseCase = GetLastCredentialActivitiesUseCaseProtocolSpy()

    viewModel = CredentialDetailsCardViewModel(
      credential: mockCredential,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase,
      getLastCredentialActivitiesUseCase: getLastCredentialActivitiesUseCase)
  }

  func testInitialState() {
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertNil(viewModel.stateError)
    XCTAssertNil(viewModel.credentialDetailBody)
    XCTAssertFalse(viewModel.isDeleteCredentialPresented)
    XCTAssertFalse(viewModel.isActivitiesListPresented)
    XCTAssertFalse(viewModel.isPoliceQRCodePresented)
    XCTAssertFalse(viewModel.isCredentialDetailsPresented)
    XCTAssertTrue(viewModel.activities.isEmpty)
    XCTAssertFalse(viewModel.hasActivities)
    XCTAssertFalse(viewModel.isActivityDetailPresented)
    XCTAssertNil(viewModel.selectedActivity)
  }

  func testLoadcredentialDetailBody_withStatusCheckSucceed_success() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = mockCredential
    getLastCredentialActivitiesUseCase.executeForCountReturnValue = [.Mock.sampleReceive, .Mock.samplePresentation]

    await viewModel.send(event: .checkStatus)

    XCTAssertNotNil(viewModel.credentialDetailBody)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)

    XCTAssertTrue(getLastCredentialActivitiesUseCase.executeForCountCalled)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.count, mockCount)
  }

  func testLoadcredentialDetailBody_withStatusCheckFailed_success() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForThrowableError = TestingError.error
    getLastCredentialActivitiesUseCase.executeForCountReturnValue = [.Mock.sampleReceive, .Mock.samplePresentation]

    await viewModel.send(event: .checkStatus)

    XCTAssertNotNil(viewModel.credentialDetailBody)
    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)

    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(checkAndUpdateCredentialStatusUseCase.executeForCallsCount, 1)

    XCTAssertTrue(getLastCredentialActivitiesUseCase.executeForCountCalled)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.count, mockCount)
  }

  func testGetLastCredential_success() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = mockCredential
    getLastCredentialActivitiesUseCase.executeForCountReturnValue = [.Mock.sampleReceive, .Mock.samplePresentation]

    await viewModel.send(event: .getLastActivities)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.activities.count, 2)
    XCTAssertTrue(viewModel.hasActivities)

    XCTAssertTrue(getLastCredentialActivitiesUseCase.executeForCountCalled)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.count, mockCount)
  }

  func testGetLastCredential_fails() async throws {
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = mockCredential
    getLastCredentialActivitiesUseCase.executeForCountThrowableError = TestingError.error

    await viewModel.send(event: .getLastActivities)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertNil(viewModel.stateError)
    XCTAssertTrue(viewModel.activities.isEmpty)
    XCTAssertFalse(viewModel.hasActivities)

    XCTAssertTrue(getLastCredentialActivitiesUseCase.executeForCountCalled)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.credential, mockCredential)
    XCTAssertEqual(getLastCredentialActivitiesUseCase.executeForCountReceivedArguments?.count, mockCount)
  }

  func testShowActivities() {
    viewModel.showActivitiesView()
    XCTAssertTrue(viewModel.isActivitiesListPresented)
  }

  func testShowActivityDetail() {
    viewModel.showActivityDetail()
    XCTAssertTrue(viewModel.isActivityDetailPresented)
  }

  // MARK: Private

  private let mockCredential: Credential = .Mock.sample
  private let mockCount: Int = 3

  // swiftlint:disable all
  private var viewModel: CredentialDetailsCardViewModel!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var getLastCredentialActivitiesUseCase: GetLastCredentialActivitiesUseCaseProtocolSpy!
  // swiftlint:enable all
}
