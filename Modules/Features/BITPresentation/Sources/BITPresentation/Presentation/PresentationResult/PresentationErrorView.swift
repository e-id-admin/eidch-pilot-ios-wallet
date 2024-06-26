import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - PresentationResultView

public struct PresentationErrorView: View {

  // MARK: Lifecycle

  public init(
    title: String? = nil,
    message: String? = nil,
    _ close: @escaping () -> Void,
    retry: (() -> Void)? = nil)
  {
    self.title = title ?? L10n.presentationErrorTitle
    self.message = message ?? L10n.presentationErrorMessage
    closeAction = close
    retryAction = retry
    viewModel = Container.shared.presentationErrorViewModel()
  }

  // MARK: Public

  public var body: some View {
    content
      .font(.custom.body)
      .navigationBarHidden(true)
  }

  // MARK: Private

  private var viewModel: PresentationErrorViewModel
  private var title: String
  private var message: String
  private var closeAction: () -> Void
  private var retryAction: (() -> Void)?

  private var content: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(spacing: .x6) {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80)
            .foregroundColor(.white)
            .padding(.top, .x10)

          Text(viewModel.formattedDate)
            .font(.custom.subheadline)
          Text(title)
            .tracking(-0.5)
            .font(.custom.title)
            .multilineTextAlignment(.center)
          Text(message)
            .tracking(-0.5)
            .multilineTextAlignment(.center)
        }
      }

      VStack {
        Button(action: {
          closeAction()
        }, label: {
          Label(L10n.globalBackHome, systemImage: "arrow.backward")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminentReversed)

        if let retryAction {
          Button(action: {
            retryAction()
          }, label: {
            Text(L10n.globalRetry)
              .frame(maxWidth: .infinity)
          })
          .buttonStyle(.primaryProminent)
        }
      }
      .padding(.bottom, .x4)
    }
    .padding(.horizontal, .x4)
    .foregroundColor(.white)
    .background(
      LinearGradient(gradient: Gradient(colors: [ThemingAssets.red2.swiftUIColor, ThemingAssets.red.swiftUIColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    )
  }

}
