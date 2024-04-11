import BITAppAuth
import BITCore
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - OnboardingFlowView

public struct OnboardingFlowView: View {

  // MARK: Lifecycle

  public init(viewModel: OnboardingFlowViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    content
  }

  // MARK: Internal

  @Environment(\.scenePhase) var scenePhase

  @StateObject var viewModel: OnboardingFlowViewModel

  // MARK: Private

  private var content: some View {
    OnboardingPagerView(pageCount: viewModel.pageCount, currentIndex: $viewModel.currentIndex, isSwipeEnabled: $viewModel.isSwipeEnabled, isNextButtonEnabled: $viewModel.isNextButtonEnabled, areDotsEnabled: $viewModel.areDotsEnabled) {
      OnboardingStepView(
        primary: L10n.onboardingWalletPrimary,
        secondary: L10n.onboardingWalletSecondary,
        image: Assets.start.name,
        onSkip: { viewModel.skipToPrivacyStep() }) {}

      OnboardingStepView(
        primary: L10n.onboardingQrCodePrimary,
        secondary: L10n.onboardingQrCodeSecondary,
        image: Assets.qrCode.name,
        onSkip: { viewModel.skipToPrivacyStep() }) {}

      PrivacyOnboardingStepView()

      PinCodeStepView(pinCode: $viewModel.pin, isKeyPadDisabled: viewModel.isKeyPadDisabled)
      ConfirmationPinCodeStepView(pinCode: $viewModel.confirmationPin, state: viewModel.pinConfirmationState) {
        viewModel.backToPinCode()
      }

      if viewModel.hasBiometricAuth {
        BiometricStepView(type: .init(type: viewModel.biometricType), registerBiometrics: $viewModel.registerBiometrics) { viewModel.skipBiometrics() }
      } else {
        UndefinedBiometricStepView { viewModel.skipBiometrics() }
      }
    }
    .background(ThemingAssets.background.swiftUIColor)
  }

}
