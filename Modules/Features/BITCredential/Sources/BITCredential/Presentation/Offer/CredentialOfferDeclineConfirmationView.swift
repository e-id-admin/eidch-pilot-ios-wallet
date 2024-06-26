import BITCredentialShared
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialOfferDeclineConfirmationView

public struct CredentialOfferDeclineConfirmationView: View {

  // MARK: Lifecycle

  public init(credential: Credential, isPresented: Binding<Bool>, onDelete: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialOfferDeclineConfirmationViewModel((credential, isPresented, onDelete)))
  }

  // MARK: Public

  public var body: some View {
    content()
      .font(.custom.body)
      .navigationBarHidden(true)
  }

  @ViewBuilder
  public func content() -> some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x4) {
          Assets.deleteCredential.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)

          Text(L10n.credentialOfferRefuseConfirmationTitle)
            .font(.custom.title)
          Text(L10n.credentialOfferRefuseConfirmationMessage)
            .multilineTextAlignment(.leading)
        }
        .padding(.bottom, .x15)
      }

      VStack(alignment: .leading, spacing: .x3) {
        Button(action: {
          viewModel.cancel()
        }, label: {
          Label(L10n.credentialOfferRefuseConfirmationCancelButton, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .disabled(viewModel.isLoading)
        .buttonStyle(.secondary)

        Button(action: {
          Task {
            await viewModel.delete()
          }
        }, label: {
          if viewModel.isLoading {
            ProgressView()
              .frame(maxWidth: .infinity)
          } else {
            Label(L10n.credentialOfferRefuseConfirmationRefuseButton, systemImage: "trash")
              .frame(maxWidth: .infinity)
          }
        })
        .disabled(viewModel.isLoading)
        .buttonStyle(.primaryProminentDestructive)
        .animation(.default, value: viewModel.isLoading)
      }
      .background(ThemingAssets.background.swiftUIColor)
    }
    .padding([.bottom, .horizontal], .x4)
  }

  // MARK: Internal

  @StateObject var viewModel: CredentialOfferDeclineConfirmationViewModel
}
