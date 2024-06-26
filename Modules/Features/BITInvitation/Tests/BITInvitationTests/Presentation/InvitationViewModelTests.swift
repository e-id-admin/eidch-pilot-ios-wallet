import BITNetworking
import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITInvitation
@testable import BITPresentation
@testable import BITPresentationMocks
@testable import BITSdJWTMocks
@testable import BITTestingCore

// MARK: - InvitationViewModelTests

@MainActor
final class InvitationViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockRequestObject = .Mock.sample
    viewModel = createViewModel(mode: .qr)
  }

  func testWithInitialData() async {
    XCTAssertTrue(viewModel.compatibleCredentials.isEmpty)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(viewModel.isTipPresented)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertNil(viewModel.requestId)
    XCTAssertNil(viewModel.requestObject)
    XCTAssertNil(viewModel.metadataUrl)
    XCTAssertNil(viewModel.stateError)
    XCTAssertNil(viewModel.qrScannerError)
    XCTAssertNil(viewModel.offer)
  }

  func testValidateCredentialOfferSuccess() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample
    saveCredentialUseCase.executeSdJWTMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertTrue(viewModel.isOfferPresented)
    XCTAssertFalse(mockRouter.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeSdJWTMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)

    XCTAssertTrue(addActivityUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, credential)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .credentialReceived)
    XCTAssertNil(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier)
  }

  func testValidateCredentialOfferSuccess_withRouter() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    let useCases = useCases(mode: .qr)
    let viewModel = InvitationViewModel(routes: mockRouter, useCases: useCases)

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample
    saveCredentialUseCase.executeSdJWTMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertTrue(mockRouter.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeSdJWTMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)

    XCTAssertTrue(addActivityUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, credential)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .credentialReceived)
    XCTAssertNil(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier)
  }

  func testValidateCredentialOfferSuccess_whenAddActivityFails() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    let useCases = useCases(mode: .qr)
    let viewModel = InvitationViewModel(routes: mockRouter, useCases: useCases)

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample
    saveCredentialUseCase.executeSdJWTMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    addActivityUseCase.executeTypeCredentialVerifierThrowableError = TestingError.error

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertTrue(mockRouter.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeSdJWTMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)

    XCTAssertTrue(addActivityUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, credential)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .credentialReceived)
    XCTAssertNil(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier)
  }

  func testValidateCredentialOfferSuccess_deeplink() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample
    let expectation = XCTestExpectation(description: "Async operation completes")

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample
    saveCredentialUseCase.executeSdJWTMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForClosure = { credential in
      expectation.fulfill()
      return credential
    }

    viewModel = createViewModel(mode: .deeplink(url: url))

    await fulfillment(of: [expectation], timeout: 5.0)

    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertTrue(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeSdJWTMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)

    XCTAssertTrue(addActivityUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.credential, credential)
    XCTAssertEqual(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.type, .credentialReceived)
    XCTAssertNil(addActivityUseCase.executeTypeCredentialVerifierReceivedArguments?.verifier)
  }

  func testValidateCredentialOfferFailure() async {

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeThrowableError = ValidateCredentialOfferInvitationUrlError.unexpectedScheme

    viewModel.isTorchEnabled = true
    viewModel.isTorchAvailable = true

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertTrue(viewModel.isTorchEnabled)
    XCTAssertTrue(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertFalse(addActivityUseCase.executeTypeCredentialVerifierCalled)
  }

  func testValidateCredentialOfferPinningFailure() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromThrowableError = NetworkError(status: .pinning)

    viewModel.isTorchEnabled = true

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.state, .wrongIssuer)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(fetchMetadataUseCase.executeFromCallsCount, 1)

    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertFalse(addActivityUseCase.executeTypeCredentialVerifierCalled)
  }

  func testValidateCredentialOfferMismatchFailure() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = CredentialJWTValidatorError.credentialMismatch

    viewModel.isTorchEnabled = true

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.state, .credentialMismatch)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(fetchMetadataUseCase.executeFromCallsCount, 1)

    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount, 1)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertFalse(addActivityUseCase.executeTypeCredentialVerifierCalled)
  }

  func testFetchCredentialExpired() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = FetchCredentialError.expiredInvitation

    viewModel.isTorchEnabled = true

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.state, .expiredInvitation)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(fetchMetadataUseCase.executeFromCallsCount, 1)

    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount, 1)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(addActivityUseCase.executeTypeCredentialVerifierCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
  }

  func testValidatePresentationWithOneCredentialSuccess() async {
    let mockCredential: Credential = .Mock.sample
    let mockCompatibleCredential = CompatibleCredential(credential: mockCredential, fields: [])

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    getCompatibleCredentialsUseCase.executeRequestObjectReturnValue = [mockCompatibleCredential]

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.requestObject)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(mockRequestObject, viewModel.requestObject)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertTrue(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)
    XCTAssertEqual(mockRequestObject, getCompatibleCredentialsUseCase.executeRequestObjectReceivedRequestObject)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testValidatePresentationWithMultipleCredentialSuccess() async {
    let mockCredential: Credential = .Mock.sample
    let mockCompatibleCredential = CompatibleCredential(credential: mockCredential, fields: [])

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    getCompatibleCredentialsUseCase.executeRequestObjectReturnValue = [mockCompatibleCredential, mockCompatibleCredential]

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.requestObject)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(mockRequestObject, viewModel.requestObject)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertTrue(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)
    XCTAssertEqual(mockRequestObject, getCompatibleCredentialsUseCase.executeRequestObjectReceivedRequestObject)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testValidatePresentationFailure() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNil(viewModel.requestObject)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .qrScanner)
    XCTAssertTrue(viewModel.isPopupErrorPresented)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(0, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testValidatePresentationEmptyCompatibleCredentialsFailure() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    getCompatibleCredentialsUseCase.executeRequestObjectReturnValue = []

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .noCompatibleCredentials)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testValidatePresentationInvalidInvitationFail() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = FetchRequestObjectError.invalidPresentationInvitation

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNil(viewModel.requestObject)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .qrScanner)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(0, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testEmptyWalletPath() async throws {
    getCompatibleCredentialsUseCase.executeRequestObjectThrowableError = CompatibleCredentialsError.noCredentials
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject

    // swiftlint: disable all
    await viewModel.send(event: .checkInvitationType(.init(string: "http://")!))
    // swiftlint: enable all

    XCTAssertEqual(viewModel.state, .emptyWallet)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)
    XCTAssertTrue(viewModel.compatibleCredentials.isEmpty)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testNoCompatibleCredentialsPath() async throws {
    getCompatibleCredentialsUseCase.executeRequestObjectThrowableError = CompatibleCredentialsError.noCompatibleCredentials
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject

    // swiftlint: disable all
    await viewModel.send(event: .checkInvitationType(.init(string: "http://")!))
    // swiftlint: enable all

    XCTAssertEqual(viewModel.state, .noCompatibleCredentials)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeRequestObjectCallsCount)
    XCTAssertTrue(viewModel.compatibleCredentials.isEmpty)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testFetchMetadataFailed_networkError() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = .Mock.sample
    fetchMetadataUseCase.executeFromThrowableError = NetworkError(status: .noConnection)
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample

    await viewModel.send(event: .setMetadataUrl(url))

    assertsNoInternetConnexion()
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
  }

  func testFetchCredentialFailed_networkError() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = .Mock.sample
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = NetworkError(status: .noConnection)
    saveCredentialUseCase.executeSdJWTMetadataWrapperReturnValue = .Mock.sample
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = .Mock.sample

    await viewModel.send(event: .setMetadataUrl(url))

    assertsNoInternetConnexion()
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
  }

  func testFetchCredentialRetry() async throws {
    await testFetchCredentialFailed_networkError()

    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = nil
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = .Mock.sample

    await viewModel.send(event: .retry)

    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertTrue(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertTrue(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
  }

  func testSubmitPresentationFailed_networkError() async {
    let mockCredential: Credential = .Mock.sample
    let mockCompatibleCredential = CompatibleCredential(credential: mockCredential, fields: [])

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = NetworkError(status: .noConnection)
    getCompatibleCredentialsUseCase.executeRequestObjectReturnValue = [mockCompatibleCredential]

    await viewModel.send(event: .setMetadataUrl(url))

    XCTAssertNil(viewModel.offer)
    XCTAssertNil(viewModel.requestObject)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertEqual(viewModel.state, .noInternetConnexion)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  func testSubmitPresentationRetry() async throws {
    await testSubmitPresentationFailed_networkError()

    fetchRequestObjectUseCase.executeThrowableError = nil
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject

    await viewModel.send(event: .retry)

    try await Task.sleep(nanoseconds: 1_100_000_000)

    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.requestObject)
    XCTAssertNil(viewModel.stateError)
    XCTAssertEqual(mockRequestObject, viewModel.requestObject)
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertTrue(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertTrue(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
    XCTAssertEqual(mockRequestObject, getCompatibleCredentialsUseCase.executeRequestObjectReceivedRequestObject)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
  }

  // MARK: Private

  // swiftlint: disable all
  private var validateCredentialOfferInvitationUrlUseCase: ValidateCredentialOfferInvitationUrlUseCaseProtocolSpy!
  private var fetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocolSpy!
  private var checkInvitationTypeUseCase: CheckInvitationTypeUseCaseProtocolSpy!
  private var getCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocolSpy!
  private var fetchMetadataUseCase: FetchMetadataUseCaseProtocolSpy!
  private var fetchCredentialUseCase: FetchCredentialUseCaseProtocolSpy!
  private var saveCredentialUseCase: SaveCredentialUseCaseProtocolSpy!
  private var checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocolSpy!
  private var addActivityUseCase: AddActivityToCredentialUseCaseProtocolSpy!
  private var mockRequestObject: RequestObject!

  private var mockRouter = InvitationRouterMock()

  private var viewModel: InvitationViewModel!

  private let url = URL(string: "openid-credential-offer://url")!
  // swiftlint: enable all
}

extension InvitationViewModelTests {

  private enum InvitationMode: Equatable {
    case deeplink(url: URL)
    case qr
  }

  private func useCases(mode: InvitationMode = .qr) -> InvitationViewModel.UseCases {
    if mode == .qr {
      getCompatibleCredentialsUseCase = GetCompatibleCredentialsUseCaseProtocolSpy()
      validateCredentialOfferInvitationUrlUseCase = ValidateCredentialOfferInvitationUrlUseCaseProtocolSpy()
      checkInvitationTypeUseCase = CheckInvitationTypeUseCaseProtocolSpy()
      fetchRequestObjectUseCase = FetchRequestObjectUseCaseProtocolSpy()
      fetchMetadataUseCase = FetchMetadataUseCaseProtocolSpy()
      fetchCredentialUseCase = FetchCredentialUseCaseProtocolSpy()
      saveCredentialUseCase = SaveCredentialUseCaseProtocolSpy()
      checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
      addActivityUseCase = AddActivityToCredentialUseCaseProtocolSpy()
    } else {
      let reason = "use cases have to be configured in advance for the deeplink testing mode"
      XCTAssertNotNil(getCompatibleCredentialsUseCase, reason)
      XCTAssertNotNil(validateCredentialOfferInvitationUrlUseCase, reason)
      XCTAssertNotNil(checkInvitationTypeUseCase, reason)
      XCTAssertNotNil(fetchRequestObjectUseCase, reason)
      XCTAssertNotNil(fetchMetadataUseCase, reason)
      XCTAssertNotNil(fetchCredentialUseCase, reason)
      XCTAssertNotNil(saveCredentialUseCase, reason)
      XCTAssertNotNil(checkAndUpdateCredentialStatusUseCase, reason)
    }

    return InvitationViewModel.UseCases(
      validateCredentialOfferInvitationUrlUseCase: validateCredentialOfferInvitationUrlUseCase,
      fetchRequestObjectUseCase: fetchRequestObjectUseCase,
      checkInvitationTypeUseCase: checkInvitationTypeUseCase,
      getCompatibleCredentialsUseCase: getCompatibleCredentialsUseCase,
      fetchMetadataUseCase: fetchMetadataUseCase,
      fetchCredentialUseCase: fetchCredentialUseCase,
      saveCredentialUseCase: saveCredentialUseCase,
      checkAndUpdateCredentialStatusUseCase: checkAndUpdateCredentialStatusUseCase,
      addActivityUseCase: addActivityUseCase)
  }

  private func createViewModel(mode: InvitationMode = .qr) -> InvitationViewModel {
    let useCases = useCases(mode: mode)

    switch mode {
    case .qr: return .init(useCases: useCases)
    case .deeplink(let url): return .init(url, useCases: useCases)
    }
  }

  private func assertsNoInternetConnexion() {
    XCTAssertNil(viewModel.offer)
    XCTAssertNotNil(viewModel.stateError)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.state, .noInternetConnexion)
    XCTAssertFalse(viewModel.isOfferPresented)
    XCTAssertFalse(viewModel.isPresentationPresented)
    XCTAssertFalse(viewModel.isCredentialSelectionPresented)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchAvailable)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)
    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(saveCredentialUseCase.executeSdJWTMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeRequestObjectCalled)
  }

}
