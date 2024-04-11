import BITTheming
import Factory
import SwiftUI

// MARK: - PresentationResultView

public struct PresentationResultView: View {

  // MARK: Lifecycle

  public init(presentationMetadata: PresentationMetadata, _ completed: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: Container.shared.presentationResultViewModel((presentationMetadata, completed)))
  }

  // MARK: Public

  public var body: some View {
    content
      .font(.custom.body)
      .navigationBarHidden(true)
  }

  // MARK: Internal

  @StateObject var viewModel: PresentationResultViewModel

  // MARK: Private

  private var content: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(spacing: .x6) {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80)
            .foregroundColor(.white)
            .padding(.top, .x10)

          VStack(spacing: 0) {
            Text(viewModel.date)
              .font(.custom.subheadline)
            Text(L10n.presentationResultTitle)
              .tracking(-0.5)
              .font(.custom.title)
              .multilineTextAlignment(.center)
          }

          PresentationResultFieldListView(fields: viewModel.presentationMetadata.attributes, header: L10n.presentationResultListTitle)
            .padding()
            .background(ThemingAssets.background.swiftUIColor)
            .foregroundColor(Color.primary)
            .clipShape(.rect(cornerRadius: 4))
        }
      }

      Button(action: {
        viewModel.completed()
      }, label: {
        Label(L10n.globalBackHome, systemImage: "arrow.right")
          .frame(maxWidth: .infinity)
          .labelStyle(.titleAndIconReversed)
      })
      .buttonStyle(.primaryProminentReversed)
      .padding(.bottom, .x4)
    }
    .padding(.horizontal, .x4)
    .foregroundColor(.white)
    .background(
      LinearGradient(gradient: Gradient(colors: [ThemingAssets.green2.swiftUIColor, ThemingAssets.green.swiftUIColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    )
  }
}
