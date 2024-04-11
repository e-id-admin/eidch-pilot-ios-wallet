import BITAppAuth
import SwiftUI

struct ConfirmationPinCodeStepView: View {

  @Binding var pinCode: PinCode
  var state: PinCodeState
  let backPressed: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      StepViewHeader()

      Text(L10n.onboardingPinCodeConfirmationTitle)
        .font(.custom.title)
        .multilineTextAlignment(.leading)
      PinCodeView(pinCode: $pinCode, state: state, text: L10n.onboardingPinCodeConfirmationText)
        .keyPadLeftKey(.back) {
          backPressed()
        }
    }
    .padding(.x4)
  }
}

#Preview {
  PinCodeStepView(pinCode: .constant("1234"))
}
