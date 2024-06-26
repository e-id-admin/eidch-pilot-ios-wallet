import BITActivity
import BITTheming
import Factory
import SwiftUI

// MARK: - ActivityDetailView

public struct ActivityDetailView: View {

  // MARK: Lifecycle

  public init(activity: Activity, isPresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: Container.shared.activityDetailViewModel((activity, isPresented)))
  }

  // MARK: Public

  public var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        ActivityCellView(viewModel.activity, badgeSize: Defaults.badgeSize, canNavigate: false)
          .padding(.x3)

        CredentialDetailContentView(activity: viewModel.activity, title: L10n.activityDetailsClaimsTitle)

        VStack(alignment: .leading) {
          Text(L10n.activityDetailsVerifier)
            .font(.custom.headline)

          HStack {
            if let imageData = viewModel.verifierLogo {
              Image(data: imageData)?
                .applyCircleShape(size: Defaults.logoSize, padding: .x1)
            }

            if let verifierName = viewModel.verifierName {
              Text(verifierName)
            }
          }
        }
        .padding(.leading, .x6)
      }
    }
    .toolbar { toolbarContent() }
    .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Private

  private enum Defaults {
    static let badgeSize: CGFloat = 48
    static let logoSize: CGFloat = 30
  }

  @StateObject private var viewModel: ActivityDetailViewModel

  @ToolbarContentBuilder
  private func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .primaryAction) {
      Menu {
        Button(role: .destructive, action: {
          Task {
            await viewModel.deleteActivity()
          }
        }, label: {
          Label(L10n.activitiesItemDeleteButton, systemImage: "trash")
        })
      } label: {
        Image(systemName: "ellipsis.circle")
      }
    }
  }
}
