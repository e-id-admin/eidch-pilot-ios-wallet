import BITAppAuth
import BITTheming
import Factory
import SwiftUI

// MARK: - PinCodeStepView

struct PinCodeStepView: View {

  @Binding var pinCode: PinCode
  @Binding var index: Int

  var pageCount: Int
  var isKeyPadDisabled: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      StepViewHeader()

      OnboardingPinCodeView(
        pinCode: $pinCode,
        state: .normal,
        text: L10n.onboardingPinCodeTitle,
        subtitle: L10n.onboardingPinCodeText,
        isKeyPadDisabled: isKeyPadDisabled,
        pageCount: pageCount,
        index: $index)
    }
    .padding(.x4)
  }

}
