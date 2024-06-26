import BITTheming
import SwiftUI

// MARK: - UndefinedBiometricStepView

struct UndefinedBiometricStepView: View {

  // MARK: Lifecycle

  init(_ pageCount: Int, index: Binding<Int>, onSkip: @escaping () -> Void) {
    self.onSkip = onSkip
    self.pageCount = pageCount
    _index = index
  }

  // MARK: Internal

  @Binding var index: Int

  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        StepViewHeader(onSkip)

        ScrollView {
          VStack(alignment: .center, spacing: .x6) {

            VStack(spacing: .x6) {
              Image(asset: Assets.biometrics)
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            .background(Defaults.defaultBackgroundGradient)
            .clipShape(.rect(cornerRadius: .x1))

            PagerDots(pageCount: pageCount, currentIndex: $index)

            Text(L10n.biometricSetupDisabledTitle)
              .font(.custom.title)
              .multilineTextAlignment(.center)

            Text(L10n.biometricSetupDisabledContent)
              .multilineTextAlignment(.center)

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

            Spacer()
          }
        }
      }

      VStack(spacing: .x3) {
        Spacer()

        Button(action: {
          onSkip()
        }, label: {
          Label(L10n.biometricSetupDisabledSkipButton, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)

        Button(action: {
          openSettings()
        }, label: {
          Label(L10n.biometricSetupDisabledEnableButton, systemImage: "arrow.up.right")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminent)
        .labelStyle(.titleAndIconReversed)
      }
    }
    .padding(.x4)
  }

  // MARK: Private

  private enum Defaults {
    static let defaultBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.gray4.swiftUIColor, ThemingAssets.gray3.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
  }

  private var pageCount: Int
  private var onSkip: () -> Void

  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

}
