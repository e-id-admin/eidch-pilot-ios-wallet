import BITTheming
import SwiftUI

// MARK: - CredentialDeleteView

public struct CredentialDeleteView: View {

  // MARK: Lifecycle

  init(_ credential: Credential, isPresented: Binding<Bool>) {
    _isPresented = isPresented
    _viewModel = StateObject(wrappedValue: CredentialDeleteViewModel(credential: credential))
  }

  // MARK: Public

  public var body: some View {
    content
      .font(.custom.body)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Internal

  @StateObject var viewModel: CredentialDeleteViewModel
  @Binding var isPresented: Bool

  // MARK: Private

  private var content: some View {
    ZStack(alignment: .bottom) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: .x6) {
          Assets.deleteCredential.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
          Text(L10n.credentialDeleteTitle)
            .font(.custom.title)
          Text(L10n.credentialDeleteText)
          Spacer()
        }
      }
      .padding(.horizontal, .x4)
      .padding(.bottom, .x25)

      VStack {
        Button(action: {
          isPresented.toggle()
        }, label: {
          Label(L10n.credentialDeleteCancelButton, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondaryProminant)

        Button(action: {
          Task {
            try await viewModel.confirm()
          }
        }, label: {
          Label(L10n.credentialDeleteConfirmButton, systemImage: "trash")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminentDestructive)
      }
      .background(ThemingAssets.background.swiftUIColor)
      .padding(.horizontal, .x4)
      .padding(.bottom, .x4)
    }
    .background(ThemingAssets.background.swiftUIColor)
  }
}
