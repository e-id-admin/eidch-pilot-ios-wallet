import BITCore
import BITCredential
import BITInvitation
import BITSettings
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - HomeViewComposer

public struct HomeComposerView: View {

  // MARK: Lifecycle

  public init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  @StateObject public var viewModel: HomeViewModel

  public var body: some View {
    content
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("")
      .toolbar { toolbarContent() }
      .onAppear {
        Task {
          await viewModel.send(event: .refresh)
        }
      }
  }

  // MARK: Private

  private var content: some View {
    ZStack(alignment: .bottom) {
      ScrollView(showsIndicators: false) {
        switch viewModel.state {
        case .emptyWithDeletedCredential:
          CredentialsEmptyStateView()
            .padding(.bottom, .x12)

        case .emptyWithoutDeletedCredential:
          NoCredentialsEmptyStateView()
            .padding(.bottom, .x12)

        case .results:
          VStack {
            if !viewModel.credentials.isEmpty {
              CredentialCardStack(credentials: viewModel.credentials)
              Spacer()
            }
          }
          .padding(.x4)
          .padding(.bottom, .x12)

        case .error:
          EmptyStateView(.error(error: viewModel.stateError)) {
            Text("Refresh")
          } action: {
            await viewModel.send(event: .refresh)
          }
        }

        NavigationLink(destination: MenuComposerView(), isActive: $viewModel.isMenuPresented) {
          EmptyView()
        }

        NavigationLink(destination: InvitationView(isPresented: $viewModel.isScannerPresented), isActive: $viewModel.isScannerPresented) {
          EmptyView()
        }
      }

      Button {
        viewModel.isScannerPresented.toggle()
      } label: {
        Label(title: { Text(L10n.homeQrCodeScanButton) }, icon: { Image(systemName: "qrcode.viewfinder") })
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.primaryProminent)
      .padding()
    }
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      HomeAssets.inAppLogo.swiftUIImage
    }

    ToolbarItem(placement: .primaryAction) {
      Button {
        viewModel.isMenuPresented.toggle()
      } label: {
        Image(systemName: "ellipsis.circle")
      }
    }
  }

}

#Preview {
  HomeComposerView(viewModel: HomeModule().viewModel)
}
