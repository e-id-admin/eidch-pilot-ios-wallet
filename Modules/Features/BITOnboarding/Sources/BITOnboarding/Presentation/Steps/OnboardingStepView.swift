import BITCore
import BITTheming
import SwiftUI

struct OnboardingStepView<Content: View>: View {

  // MARK: Lifecycle

  init(primary: String, secondary: String, image: String, onSkip: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
    self.primary = primary
    self.secondary = secondary
    self.image = image
    self.onSkip = onSkip
    self.content = content()
  }

  // MARK: Internal

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x6) {

        StepViewHeader(onSkip)

        Text(primary)
          .font(.custom.title)
          .multilineTextAlignment(.leading)
        Image(image, bundle: .module)
          .resizable()
          .scaledToFit()

        Text(secondary)
          .font(.custom.body)
          .multilineTextAlignment(.leading)

        content

        Spacer()
      }
    }
    .padding(.horizontal, .x5)
  }

  // MARK: Private

  private var primary: String
  private var secondary: String
  private var image: String
  private var onSkip: (() -> Void)?
  private var content: Content

}
