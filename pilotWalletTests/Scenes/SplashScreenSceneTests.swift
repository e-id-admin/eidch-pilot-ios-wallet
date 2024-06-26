import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITSecurity
@testable import pilotWallet

@MainActor
final class SplashScreenSceneTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()

    sceneManagerDelegate = SceneManagerDelegateSpy()
    hasDevicePinUseCase = HasDevicePinUseCaseProtocolSpy()
    jailbreakDetector = JailbreakDetectorProtocolSpy()

    scene = SplashScreenScene(hasDevicePinUseCase: hasDevicePinUseCase, jailbreakDetector: jailbreakDetector)
    scene.delegate = sceneManagerDelegate
  }

  func testHappyPath() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = false
    UserDefaults.standard.setValue(false, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == AppScene.self }))
  }

  func testNoDevicePinCode() {
    hasDevicePinUseCase.executeReturnValue = false
    jailbreakDetector.isDeviceJailbrokenReturnValue = false

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == NoDevicePinCodeScene.self }))
  }

  func testOnboardingEnabled() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = false
    UserDefaults.standard.setValue(true, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == OnboardingScene.self }))
  }

  func testDeviceJailbreak() {
    hasDevicePinUseCase.executeReturnValue = true
    jailbreakDetector.isDeviceJailbrokenReturnValue = true
    UserDefaults.standard.setValue(true, forKey: "rootOnboardingIsEnabled")

    scene.didCompleteSplashScreen()

    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedCalled)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedCallsCount, 1)
    XCTAssertEqual(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.count, 1)
    XCTAssertTrue(sceneManagerDelegate.changeSceneToAnimatedReceivedInvocations.contains(where: { $0.sceneManager == JailbreakScene.self }))
  }

  // MARK: Private

  // swiftlint:disable all
  private var scene: SplashScreenScene!
  private var sceneManagerDelegate: SceneManagerDelegateSpy!
  private var hasDevicePinUseCase: HasDevicePinUseCaseProtocolSpy!
  private var jailbreakDetector: JailbreakDetectorProtocolSpy!
  // swiftlint:enable all

}
