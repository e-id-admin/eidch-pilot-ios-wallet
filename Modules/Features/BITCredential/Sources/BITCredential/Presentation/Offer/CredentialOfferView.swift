import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialOfferView

public struct CredentialOfferView: View {

  // MARK: Lifecycle

  public init(viewModel: CredentialOfferViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    content
      .font(.custom.body)
      .navigationBarHidden(true)
  }

  public var content: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x4) {
        if let preferredIssuerDisplay = viewModel.credential.preferredIssuerDisplay {
          CredentialOfferHeaderView(viewModel: Container.shared.credentialOfferHeaderViewModel(preferredIssuerDisplay))
            .padding(.x4)
        }

        CredentialDetailContentView(credential: viewModel.credential)

        VStack(alignment: .leading, spacing: .x3) {
          Button(action: {
            viewModel.refuse()
          }, label: {
            Label(L10n.credentialOfferRefuseButton, systemImage: "xmark")
              .frame(maxWidth: .infinity)
          })
          .buttonStyle(.secondaryProminant)

          Button(action: {
            viewModel.accept()
          }, label: {
            Label(L10n.credentialOfferAcceptButton, systemImage: "checkmark")
              .frame(maxWidth: .infinity)
          })
          .buttonStyle(.primaryProminentSecondary)
        }
        .padding([.bottom, .horizontal], .x4)
      }

      NavigationLink(destination: CredentialOfferDeclineConfirmationView(credential: viewModel.credential, isPresented: $viewModel.isConfirmationScreenPresented, onDelete: { viewModel.backHome() }), isActive: $viewModel.isConfirmationScreenPresented) {
        EmptyView()
      }

    }
  }

  // MARK: Internal

  @StateObject var viewModel: CredentialOfferViewModel
}
