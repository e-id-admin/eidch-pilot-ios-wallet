import BITAppAuth
import SwiftUI

struct ConfirmationPinCodeStepView: View {

  @Binding var index: Int
  @Binding var pinCode: PinCode

  var pageCount: Int
  var state: PinCodeState
  let backPressed: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      StepViewHeader()

      OnboardingPinCodeView(
        pinCode: $pinCode,
        state: state,
        text: L10n.onboardingPinCodeConfirmationTitle,
        subtitle: L10n.onboardingPinCodeConfirmationText,
        isKeyPadDisabled: false,
        pageCount: pageCount,
        index: $index).keyPadLeftKey(.cancel) {
          backPressed()
        }
    }
    .padding(.x4)
  }
}
