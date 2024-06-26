import BITActivity
import BITCredentialShared
import BITTheming
import Factory
import Refresher
import SwiftUI

// MARK: - CredentialDetailsCardView

public struct CredentialDetailsCardView: View {

  // MARK: Lifecycle

  public init(credential: Credential, isPresented: Binding<Bool>) {
    _isPresented = isPresented
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDetailsCardViewModel(credential))
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      VStack(spacing: .x8) {
        CredentialCard(viewModel.credential, maximumPosition: 1)
          .padding(.horizontal, .x3)
        VStack {
          switch viewModel.state {
          case .loading:
            ProgressView()
          case .results:
            if viewModel.hasActivities {
              activitiesView
            }
          }
        }
      }
      .padding(.top, .x4)
    }
    .refresher {
      await viewModel.send(event: .checkStatus)
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar { toolbarContent() }
    .onAppear {
      Task {
        await viewModel.send(event: .didAppear)
      }
    }

    NavigationLink(destination: CredentialDetailView(credential: viewModel.credential, isPresented: $isPresented), isActive: $viewModel.isCredentialDetailsPresented) {
      EmptyView()
    }

    NavigationLink(destination: CredentialDeleteView(viewModel.credential, isPresented: $viewModel.isDeleteCredentialPresented, isHomePresented: $isPresented), isActive: $viewModel.isDeleteCredentialPresented) {
      EmptyView()
    }

    if let policeQrCodeData = viewModel.qrPoliceQRcode {
      NavigationLink(destination: PoliceQRCodeView(qrCodeData: policeQrCodeData), isActive: $viewModel.isPoliceQRCodePresented) {
        EmptyView()
      }
    }

    NavigationLink(destination: CredentialActivitiesView(viewModel.credential, isPresented: $isPresented), isActive: $viewModel.isActivitiesListPresented) {
      EmptyView()
    }

    if let activity = viewModel.selectedActivity {
      NavigationLink(destination: ActivityDetailView(activity: activity, isPresented: $viewModel.isActivityDetailPresented), isActive: $viewModel.isActivityDetailPresented) {
        EmptyView()
      }
    }
  }

  // MARK: Private

  @Binding private var isPresented: Bool
  @StateObject private var viewModel: CredentialDetailsCardViewModel

  private var activitiesView: some View {
    VStack(alignment: .leading) {
      Text(L10n.credentialActivitiesHeaderText)
        .font(.custom.title2.bold())
        .padding(.horizontal, .x2)

      VStack {
        ForEach(viewModel.activities) { activity in
          VStack {
            if activity.type.canNavigate {

              Button(action: {
                viewModel.selectedActivity = activity
                withAnimation {
                  viewModel.showActivityDetail()
                }
              }, label: {
                ActivityCellView(activity)
                  .contentShape(Rectangle())
              })
              .buttonStyle(.flatLink)

            } else {
              ActivityCellView(activity)
            }
          }
          .padding(.horizontal, .x2)

          Divider()
            .padding(.vertical, .x2)
        }
      }
      .padding(.top, .x3)

      Button(action: viewModel.showActivitiesView) {
        HStack(spacing: .x4) {
          DefaultBadge(systemName: "arrow.left.arrow.right", color: .black)

          Text(L10n.credentialActivitiesFooterText)
            .font(.custom.headline2)

          Spacer()

          Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.flatLink)
      .padding(.horizontal, .x2)
    }
    .padding(.horizontal, .x3)
  }

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .primaryAction) {
      Menu {
        Button(action: {
          viewModel.isCredentialDetailsPresented.toggle()
        }, label: {
          Label(L10n.credentialMenuDetailsText, systemImage: "info.circle")
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
