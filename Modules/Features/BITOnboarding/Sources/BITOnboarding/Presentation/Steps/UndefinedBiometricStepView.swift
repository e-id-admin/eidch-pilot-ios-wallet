import BITAppAuth
import BITTheming
import SwiftUI

// MARK: - UndefinedBiometricStepView

struct UndefinedBiometricStepView: View {

  // MARK: Lifecycle

  init(_ onSkip: @escaping () -> Void) {
    self.onSkip = onSkip
  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          StepViewHeader { onSkip() }

          Text(L10n.biometricSetupDisabledTitle)
            .font(.custom.title)
            .multilineTextAlignment(.leading)

          VStack(spacing: .x6) {
            Image(asset: Assets.biometrics)
              .resizable()
              .scaledToFit()
              .frame(width: 125, height: 125)
          }
          .frame(maxWidth: .infinity)
          .padding(.x8)
          .background(ThemingAssets.gray4.swiftUIColor)
          .clipShape(.rect(cornerRadius: .x1))

          Text(L10n.biometricSetupDisabledContent)

          HStack(alignment: .top) {
            Image(systemName: "lock")
              .frame(width: .x2, height: .x2)
              .padding(.x3)
              .background(Defaults.defaultBackgroundGradient)
              .clipShape(Circle())
            Text(L10n.biometricSetupReason)
              .font(.custom.footnote2)
              .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
          }

          HStack(alignment: .firstTextBaseline) {
            Text(L10n.biometricSetupDisabledEnableButton)
            Spacer()
            Image(systemName: "arrow.up.right")
          }
          .overlay(
            VStack {
              Divider()
                .offset(x: 0, y: .x6)
            }
          )
          .contentShape(Rectangle())
          .onTapGesture {
            openSettings()
          }
          .padding(.top, .x6)

          Spacer()
        }
      }
    }
    .padding(.x4)
  }

  // MARK: Private

  private enum Defaults {
    static let defaultBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.gray4.swiftUIColor, ThemingAssets.gray3.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
  }

  private var onSkip: () -> Void

  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

}

#Preview {
  UndefinedBiometricStepView {}
}
