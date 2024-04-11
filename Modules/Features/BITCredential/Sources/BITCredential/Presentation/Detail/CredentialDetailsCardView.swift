import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialDetailsCardView

public struct CredentialDetailsCardView: View {

  // MARK: Lifecycle

  public init(credential: Credential) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDetailsCardViewModel(credential))
  }

  // MARK: Public

  public var body: some View {
    VStack {
      CredentialCard(viewModel.credential)
      Spacer()
    }
    .padding(.horizontal, .normal)
    .padding(.vertical, .x4)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(L10n.credentialNavigationTitle)
    .toolbar { toolbarContent() }
    .onFirstAppear {
      Task {
        await viewModel.send(event: .didAppear)
      }
    }

    NavigationLink(destination: CredentialDetailView(credential: viewModel.credential), isActive: $viewModel.isCredentialDetailsPresented) {
      EmptyView()
    }

    NavigationLink(destination: CredentialDeleteView(viewModel.credential, isPresented: $viewModel.isDeleteCredentialPresented), isActive: $viewModel.isDeleteCredentialPresented) {
      EmptyView()
    }

    if let policeQrCodeData = viewModel.qrPoliceQRcode {
      NavigationLink(destination: PoliceQRCodeView(qrCodeData: policeQrCodeData), isActive: $viewModel.isPoliceQRCodePresented) {
        EmptyView()
      }
    }
  }

  // MARK: Internal

  @StateObject var viewModel: CredentialDetailsCardViewModel

  // MARK: Private

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .primaryAction) {
      Menu {
        Button(action: {
          viewModel.isCredentialDetailsPresented.toggle()
        }, label: {
          Label(L10n.credentialMenuDetailsText, systemImage: "doc")
        })

        Button(action: {
          viewModel.isPoliceQRCodePresented.toggle()
        }, label: {
          Label(L10n.credentialMenuPoliceControlText, systemImage: "eye")
        })

        Button(role: .destructive, action: {
          viewModel.isDeleteCredentialPresented.toggle()
        }, label: {
          Label(L10n.credentialMenuDeleteText, systemImage: "trash")
        })
      } label: {
        Image(systemName: "ellipsis.circle")
      }
    }
  }

}
