import SwiftUI

struct StepViewHeader: View {

  // MARK: Lifecycle

  init(_ onSkip: (() -> Void)? = nil) {
    self.onSkip = onSkip
  }

  // MARK: Internal

  var body: some View {
    HStack {
      Spacer()

      if let onSkip {
        Button(action: {
          onSkip()
        }, label: {
          Text(L10n.onboardingSkip)
        })
      }
    }
    .frame(height: 40)
  }

  // MARK: Private

  private var onSkip: (() -> Void)?

}

#Preview {
  StepViewHeader()
}
