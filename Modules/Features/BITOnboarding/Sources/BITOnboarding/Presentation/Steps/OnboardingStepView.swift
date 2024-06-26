import BITTheming
import SwiftUI

struct OnboardingStepView: View {

  // MARK: Lifecycle

  init(primary: String, secondary: String, image: String, pageCount: Int, index: Binding<Int>, onSkip: (() -> Void)? = nil) {
    self.primary = primary
    self.secondary = secondary
    self.image = image
    self.onSkip = onSkip
    self.pageCount = pageCount
    _index = index
  }

  // MARK: Internal

  @Binding var index: Int

  var body: some View {
    ZStack {
      ScrollView {
        VStack(alignment: .center, spacing: .x6) {
          StepViewHeader(onSkip)

          Image(image, bundle: .module)
            .resizable()
            .scaledToFit()

          PagerDots(pageCount: pageCount, currentIndex: $index)

          Text(primary)
            .font(.custom.title)
            .multilineTextAlignment(.center)

          Text(secondary)
            .font(.custom.body)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .x5)
      }

      VStack {
        Spacer()

        Button(action: {
          index += 1
        }, label: {
          Label(L10n.onboardingContinue, systemImage: "arrow.right")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminent)
        .labelStyle(.titleAndIconReversed)
        .padding([.horizontal, .bottom], .x4)
      }
    }
  }

  // MARK: Private

  private var primary: String
  private var secondary: String
  private var image: String
  private var onSkip: (() -> Void)?
  private var pageCount: Int
}
