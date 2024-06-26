import BITTheming
import SwiftUI

// MARK: - PrivacyOnboardingStepView

struct PrivacyOnboardingStepView: View {

  // MARK: Lifecycle

  init(pageCount: Int, index: Binding<Int>, onAccept: @escaping() -> Void, onDecline: @escaping() -> Void) {
    self.onAccept = onAccept
    self.onDecline = onDecline
    self.pageCount = pageCount
    _index = index
  }

  // MARK: Internal

  @Binding var index: Int

  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .center, spacing: .x6) {
          StepViewHeader()

          Image(Assets.security.name, bundle: .module)
            .resizable()
            .scaledToFit()

          PagerDots(pageCount: pageCount, currentIndex: $index)

          Text(L10n.onboardingPrivacyPrimary)
            .font(.custom.title)
            .multilineTextAlignment(.center)

          Text(L10n.onboardingPrivacySecondary)
            .font(.custom.body)
            .multilineTextAlignment(.center)

          if let url = URL(string: L10n.onboardingPrivacyLinkValue) {
            HStack {
              Link(destination: url, label: {
                Text("\(L10n.onboardingPrivacyLinkText) \(Image(systemName: "arrow.up.right"))")
                  .underline()
                  .multilineTextAlignment(.leading)
              })
              .tint(ThemingAssets.accentColor.swiftUIColor)

              Spacer()
            }
          }

          HStack(spacing: .x6) {
            Image(systemName: "chart.pie")
              .applyCircleShape(size: 20, padding: .x3)

            Text(L10n.onboardingPrivacyToggleText)
              .font(.custom.footnote2)
              .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
          }
        }
      }
      .padding(.horizontal, .x4)

      VStack(spacing: .x3) {
        Button(action: {
          onDecline()
          increaseIndex()
        }, label: {
          Label(L10n.onboardingPrivacyDeclineLoggingButton, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)

        Button(action: {
          onAccept()
          increaseIndex()
        }, label: {
          Label(L10n.onboardingPrivacyAcceptLoggingButton, systemImage: "checkmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminent)
      }
      .padding([.bottom, .horizontal], .x4)
    }
  }

  // MARK: Private

  private let pageCount: Int
  private let onAccept: () -> Void
  private let onDecline: () -> Void

  private func increaseIndex() {
    index += 1
  }

}
