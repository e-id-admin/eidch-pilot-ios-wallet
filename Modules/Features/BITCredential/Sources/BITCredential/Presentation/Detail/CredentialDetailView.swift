import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialDetailView

struct CredentialDetailView: View {

  // MARK: Lifecycle

  public init(credential: Credential) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDetailViewModel(credential))
  }

  // MARK: Internal

  var body: some View {
    content
      .navigationTitle(L10n.credentialDetailNavigationTitle)
      .toolbar { toolbarContent() }
      .onFirstAppear {
        Task {
          await viewModel.onAppear()
        }
      }

    if let policeQrCodeData = viewModel.qrPoliceQRcode {
      NavigationLink(destination: PoliceQRCodeView(qrCodeData: policeQrCodeData), isActive: $viewModel.isPoliceQRCodePresented) {
        EmptyView()
      }
    }

    NavigationLink(destination: CredentialDeleteView(viewModel.credential, isPresented: $viewModel.isDeleteCredentialPresented), isActive: $viewModel.isDeleteCredentialPresented) {
      EmptyView()
    }
  }

  // MARK: Private

  @StateObject private var viewModel: CredentialDetailViewModel

  private var content: some View {
    ScrollView {
      CredentialDetailContentView(credential: viewModel.credential)
    }
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .primaryAction) {
      Menu {
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
