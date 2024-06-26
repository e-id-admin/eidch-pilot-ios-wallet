import BITActivity
import BITCredentialShared
import BITTheming
import Factory
import Refresher
import SwiftUI

// MARK: - CredentialDetailView

struct CredentialDetailView: View {

  // MARK: Lifecycle

  public init(credential: Credential, isPresented: Binding<Bool>) {
    _isPresented = isPresented
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDetailViewModel(credential))
  }

  // MARK: Internal

  var body: some View {
    content
      .navigationTitle(L10n.credentialDetailNavigationTitle)
      .navigationBackButtonDisplayMode(.minimal)
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

    NavigationLink(destination: CredentialActivitiesView(viewModel.credential, isPresented: $isPresented), isActive: $viewModel.isActivitiesListPresented) {
      EmptyView()
    }

    NavigationLink(destination: CredentialDeleteView(viewModel.credential, isPresented: $viewModel.isDeleteCredentialPresented, isHomePresented: $isPresented), isActive: $viewModel.isDeleteCredentialPresented) {
      EmptyView()
    }
  }

  // MARK: Private

  @Binding private var isPresented: Bool
  @StateObject private var viewModel: CredentialDetailViewModel

  private var content: some View {
    ScrollView {
      CredentialDetailContentView(credential: viewModel.credential, title: L10n.credentialOfferContentSectionTitle, message: L10n.credentialOfferSupportMessage)
    }
    .refresher {
      await viewModel.refresh()
    }
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .primaryAction) {
      Menu {
        Button(action: {
          viewModel.isActivitiesListPresented.toggle()
        }, label: {
          Label(L10n.credentialMenuActivitiesText, systemImage: "clock")
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
