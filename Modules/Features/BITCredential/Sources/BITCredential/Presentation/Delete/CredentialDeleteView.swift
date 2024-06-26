import BITCredentialShared
import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialDeleteView

public struct CredentialDeleteView: View {

  // MARK: Lifecycle

  init(_ credential: Credential, isPresented: Binding<Bool>, isHomePresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDeleteViewModel((credential, isPresented: isPresented, isHomePresented: isHomePresented)))
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
        Button(action: viewModel.cancel, label: {
          Label(L10n.credentialDeleteCancelButton, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)

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
