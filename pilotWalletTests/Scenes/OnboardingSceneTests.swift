
import Factory
import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITOnboarding
@testable import pilotWallet

// MARK: - OnboardingSceneTests

@MainActor
final class OnboardingSceneTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    sceneManagerDelegate = SceneManagerDelegateSpy()
    hasDevicePinUseCase = HasDevicePinUseCaseProtocolSpy()

    Container.shared.onBoardingFlowViewModel.register { _ in
      MockOnboardingViewModel()
    }

    scene = OnboardingScene(hasDevicePinUseCase: hasDevicePinUseCase)

    scene.delegate = sceneManagerDelegate
  }

  @MainActor
  func testHappyPath_completion() async {
    (scene.module.viewModel as? MockOnboardingViewModel)?.done()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == AppScene.self }))
  }

  func testHappyPath_willEnterForeground() {
    hasDevicePinUseCase.executeReturnValue = true
    scene.willEnterForeground()

    XCTAssertFalse(sceneManagerDelegate.changeSceneToAnimatedCalled)
  }

  func testNoDevicePinCode() {
    hasDevicePinUseCase.executeReturnValue = false
    scene.willEnterForeground()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == NoDevicePinCodeScene.self }))
  }

  // MARK: Private

  // swiftlint:disable all
  private var scene: OnboardingScene!
  private var sceneManagerDelegate: SceneManagerDelegateSpy!
  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocolSpy!
  // swiftlint:enable all

}

// MARK: - MockOnboardingViewModel

final class MockOnboardingViewModel: OnboardingFlowViewModel {

  // MARK: Lifecycle

  init() {
    super.init(routes: MockOnboardingRoutes())
  }

  // MARK: Internal

  func done() {
    delegate?.didCompleteOnboarding()
  }

}

// MARK: - MockOnboardingRoutes

final class MockOnboardingRoutes: OnboardingRouter.Routes {

  func close(onComplete: (() -> Void)?) {}
  func close() {}
  func pop() {}
  func popToRoot() {}
  func dismiss() {}

}
