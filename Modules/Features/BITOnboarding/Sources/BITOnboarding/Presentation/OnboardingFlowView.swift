import BITAppAuth
import BITTheming
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
    OnboardingPagerView(pageCount: viewModel.pageCount, currentIndex: $viewModel.currentIndex, isSwipeEnabled: $viewModel.isSwipeEnabled) {
      OnboardingStepView(
        primary: L10n.onboardingWalletPrimary,
        secondary: L10n.onboardingWalletSecondary,
        image: Assets.start.name,
        pageCount: viewModel.pageCount,
        index: $viewModel.currentIndex,
        onSkip: { viewModel.skipToPrivacyStep() })

      OnboardingStepView(
        primary: L10n.onboardingQrCodePrimary,
        secondary: L10n.onboardingQrCodeSecondary,
        image: Assets.qrCode.name,
        pageCount: viewModel.pageCount,
        index: $viewModel.currentIndex,
        onSkip: { viewModel.skipToPrivacyStep() })

      PrivacyOnboardingStepView(
        pageCount: viewModel.pageCount,
        index: $viewModel.currentIndex,
        onAccept: {
          Task {
            await viewModel.acceptPrivacyPolicy()
          }
        }, onDecline: {
          Task {
            await viewModel.declinePrivacyPolicy()
          }
        })

      PinCodeStepView(
        pinCode: $viewModel.pin,
        index: $viewModel.currentIndex,
        pageCount: viewModel.pageCount,
        isKeyPadDisabled: viewModel.isKeyPadDisabled)

      ConfirmationPinCodeStepView(
        index: $viewModel.currentIndex,
        pinCode: $viewModel.confirmationPin,
        pageCount: viewModel.pageCount,
        state: viewModel.pinConfirmationState)
      {
        viewModel.backToPinCode()
      }

      if viewModel.hasBiometricAuth {
        BiometricStepView(
          type: BiometricStepType(type: viewModel.biometricType),
          registerBiometrics: $viewModel.registerBiometrics,
          pageCount: viewModel.pageCount, index: $viewModel.currentIndex) { viewModel.skipBiometrics() }
      } else {
        UndefinedBiometricStepView(viewModel.pageCount, index: $viewModel.currentIndex) { viewModel.skipBiometrics() }
      }
    }
    .background(ThemingAssets.background.swiftUIColor)
  }
}
