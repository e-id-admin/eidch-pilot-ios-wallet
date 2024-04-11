import BITAppAuth
import BITTheming
import SwiftUI

// MARK: - BiometricStepView

struct BiometricStepView: View {

  // MARK: Lifecycle

  init(type: BiometricStepType, registerBiometrics: Binding<Bool>, _ onSkip: @escaping () -> Void) {
    self.onSkip = onSkip
    self.type = type
    _registerBiometrics = registerBiometrics
  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading) {
          StepViewHeader { onSkip() }

          Text(L10n.onboardingBiometricTitle(type.text))
            .font(.custom.title)
            .multilineTextAlignment(.leading)

          VStack(spacing: .x6) {
            type.image
              .resizable()
              .scaledToFit()
              .frame(width: 125, height: 125)
              .font(.system(size: 12, weight: .ultraLight))
          }
          .frame(maxWidth: .infinity)
          .padding(.x8)
          .background(Defaults.defaultBackgroundGradient)
          .clipShape(.rect(cornerRadius: .x1))

          Text(L10n.onboardingBiometricText(type.text))

          HStack(alignment: .top) {
            Image(systemName: "lock")
              .frame(width: .x2, height: .x2)
              .padding(.x3)
              .background(ThemingAssets.gray4.swiftUIColor)
              .clipShape(Circle())
            Text(L10n.onboardingBiometricInfo(type.text))
              .font(.custom.footnote2)
              .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
          }

          Spacer()
        }
      }

      Button {
        registerBiometrics = true
      } label: {
        HStack {
          Text(L10n.onboardingBiometricButtonText)
          Image(systemName: "arrow.right")
        }
        .frame(maxWidth: .infinity)
      }
      .buttonStyle(.primaryProminent)
    }
    .padding(.x4)
  }

  // MARK: Private

  private enum Defaults {
    static let defaultBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.gray4.swiftUIColor, ThemingAssets.gray3.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
  }

  private var onSkip: () -> Void
  private var type: BiometricStepType
  @Binding private var registerBiometrics: Bool
}

#Preview {
  BiometricStepView(type: .faceID, registerBiometrics: .constant(false)) {}
}
