import BITTheming
import SwiftUI

// MARK: - PrivacyOnboardingStepView

struct PrivacyOnboardingStepView: View {

  @AppStorage("optimizationOptIn") var optimizationOptIn: Bool = true

  var body: some View {
    ScrollView {
      OnboardingStepView(primary: L10n.onboardingPrivacyPrimary, secondary: L10n.onboardingPrivacySecondary, image: Assets.security.name, content: {
        if let url = URL(string: L10n.onboardingPrivacyLinkValue) {
          HStack {
            Link(destination: url, label: {
              Text("\(L10n.onboardingPrivacyLinkText) \(Image(systemName: "arrow.up.right"))")
                .underline()
            })
            .tint(ThemingAssets.accentColor.swiftUIColor)
          }
        }
      })
    }
  }
}

#Preview {
  PrivacyOnboardingStepView()
}
