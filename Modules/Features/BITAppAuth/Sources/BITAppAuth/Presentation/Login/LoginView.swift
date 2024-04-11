import BITCore
import BITTheming
import Factory
import SwiftUI

// MARK: - LoginView

public struct LoginView: View {

  // MARK: Lifecycle

  public init(viewModel: LoginViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    content()
      .onAppear {
        viewModel.onAppear()
      }
      .toolbar(content: toolbarContent)
  }

  // MARK: Private

  @StateObject private var viewModel: LoginViewModel

  @ViewBuilder
  private func content() -> some View {
    VStack {
      if viewModel.isLocked {
        VStack(alignment: .leading, spacing: .x4) {
          Assets.appLocked.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
          Text(L10n.loginBlockedTitle)
            .font(.custom.title)
          Text(L10n.loginBlockedDescription(viewModel.formattedDateUnlockInterval ?? ""))
          Spacer()
        }
        .padding(.x4)
      } else {
        PinCodeView(pinCode: $viewModel.pinCode, state: viewModel.pinCodeState)
          .padding(.x4)
          .keyPadLeftKey(viewModel.isBiometricAuthenticationAvailable ? .faceId : .none) {
            Task {
              await viewModel.biometricAuthentication()
            }
          }
      }
    }
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      ThemingAssets.inAppLogo.swiftUIImage
    }
  }

}

// MARK: - LoginView_Previews

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoginView(viewModel: Container.shared.loginModule().viewModel)
    }
  }
}
