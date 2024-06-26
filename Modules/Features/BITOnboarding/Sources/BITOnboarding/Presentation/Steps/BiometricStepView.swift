import BITAppAuth
import BITTheming
import SwiftUI

// MARK: - BiometricStepView

struct BiometricStepView: View {

  // MARK: Lifecycle

  init(type: BiometricStepType, registerBiometrics: Binding<Bool>, pageCount: Int, index: Binding<Int>, _ onSkip: @escaping () -> Void) {
    self.onSkip = onSkip
    self.type = type
    self.pageCount = pageCount
    _index = index
    _registerBiometrics = registerBiometrics
  }

  // MARK: Internal

  @Binding var index: Int

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(alignment: .leading) {
        StepViewHeader(onSkip)

        ScrollView {
          VStack(alignment: .center, spacing: .x6) {

            VStack(spacing: .x6) {
              type.image
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)
                .font(.system(size: 12, weight: .ultraLight))
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            .background(Defaults.defaultBackgroundGradient)
            .clipShape(.rect(cornerRadius: .x1))

            PagerDots(pageCount: pageCount, currentIndex: $index)

            Text(L10n.onboardingBiometricTitle(type.text))
              .font(.custom.title)
              .multilineTextAlignment(.center)

            Text(L10n.onboardingBiometricInfo(type.text))
              .multilineTextAlignment(.center)

            HStack(alignment: .top) {
              Image(systemName: "lock")
                .frame(width: .x2, height: .x2)
                .padding(.x3)
                .background(ThemingAssets.gray4.swiftUIColor)
                .clipShape(Circle())
              Text(L10n.onboardingBiometricPermissionReason(type.text))
                .font(.custom.footnote2)
                .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
            }

            Spacer()
          }
        }
      }

      Button {
        registerBiometrics = true
      } label: {
        HStack {
          Text(L10n.biometricSetupActionButton(type.text))
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

  private var pageCount: Int
  private var onSkip: () -> Void
  private var type: BiometricStepType
  @Binding private var registerBiometrics: Bool
}
