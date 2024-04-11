import BITAppAuth
import SwiftUI

struct PinCodeStepView: View {

  @Binding var pinCode: PinCode
  var isKeyPadDisabled: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      StepViewHeader()

      Text(L10n.onboardingPinCodeTitle)
        .font(.custom.title)
        .multilineTextAlignment(.leading)
      PinCodeView(pinCode: $pinCode, state: .normal, text: L10n.onboardingPinCodeText, isKeyPadDisabled: isKeyPadDisabled)
    }
    .padding(.x4)
  }
}

#Preview {
  PinCodeStepView(pinCode: .constant("1234"))
}
