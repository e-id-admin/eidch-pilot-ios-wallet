import BITActivity
import BITCore
import BITCredential
import BITInvitation
import BITSettings
import BITTheming
import Factory
import Foundation
import Refresher
import SwiftUI

// MARK: - HomeComposerView

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
              CredentialCardStack(credentials: viewModel.credentials, isPresented: $viewModel.isCredentialDetailPresented)
              Spacer(minLength: .x10)

              if let activity = viewModel.lastActivity {
                LastActivityView(
                  activity,
                  onTapActivity: viewModel.showActivityDetails,
                  onTapHeader: viewModel.showActivitiesList)
              }
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

        if let credential = viewModel.lastActivityCredential {
          NavigationLink(destination: CredentialActivitiesView(credential, isPresented: $viewModel.isActivitiesListPresented), isActive: $viewModel.isActivitiesListPresented) {
            EmptyView()
          }
        }

        if let activity = viewModel.lastActivity {
          NavigationLink(destination: ActivityDetailView(activity: activity, isPresented: $viewModel.isActivityDetailPresented), isActive: $viewModel.isActivityDetailPresented) {
            EmptyView()
          }
        }
      }
      .refresher {
        await viewModel.send(event: .checkCredentialsStatus)
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
