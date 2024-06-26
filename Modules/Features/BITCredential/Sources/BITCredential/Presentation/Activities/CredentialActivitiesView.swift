import BITActivity
import BITCredentialShared
import BITTheming
import Factory
import SwiftUI

// MARK: - CredentialActivitiesView

public struct CredentialActivitiesView: View {

  // MARK: Lifecycle

  public init(_ credential: Credential, isPresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialActivitiesViewModel((credential, isPresented)))
  }

  // MARK: Public

  public var body: some View {
    VStack {
      switch viewModel.state {
      case .loading: loadingView()
      case .results: resultView()
      case .empty: emptyView()
      }
    }
    .onFirstAppear {
      Task {
        await viewModel.send(event: .didAppear)
      }
    }
    .navigationTitle(L10n.activitiesTitle)
    .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Private

  @StateObject private var viewModel: CredentialActivitiesViewModel

  @ViewBuilder
  private func resultView() -> some View {
    List {
      ForEach(viewModel.groupedActivities, id: \.key) { date, activities in
        Section(header: Text(date).foregroundStyle(ThemingAssets.secondary.swiftUIColor)) {
          ForEach(activities) { activity in
            if activity.type.canNavigate {
              ActivityCellView(activity, onDelete: { deleteActivity(activity) })
                .padding(.vertical, .x2)
                .onTapGesture {
                  selectActivity(activity)
                }
            } else {
              ActivityCellView(activity, onDelete: { deleteActivity(activity) })
                .padding(.vertical, .x2)
            }
          }
        }
      }
    }
    .listStyle(.plain)

    if let activity = viewModel.selectedActivity {
      NavigationLink(destination: ActivityDetailView(activity: activity, isPresented: $viewModel.isActivityDetailPresented), isActive: $viewModel.isActivityDetailPresented) {
        EmptyView()
      }
    }
  }

  @ViewBuilder
  private func emptyView() -> some View {
    VStack(alignment: .leading, spacing: .x4) {
      Assets.noActivities.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 300)

      Text(L10n.activitiesEmptyStateTitle)
        .font(.custom.title)

      Text(L10n.activitiesEmptyStateText)

      Spacer()

      Button(action: {
        Task {
          await viewModel.send(event: .close)
        }
      }, label: {
        Label(L10n.globalBackHome, systemImage: "arrow.left")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(.secondary)

    }
    .padding(.horizontal, .x4)
  }

  @ViewBuilder
  private func loadingView() -> some View {
    ProgressView()
  }

}

extension CredentialActivitiesView {

  private func deleteActivity(_ activity: Activity) {
    Task {
      await viewModel.send(event: .deleteActivity(activity))
    }
  }

  private func selectActivity(_ activity: Activity) {
    viewModel.selectedActivity = activity
    withAnimation {
      viewModel.showActivityDetailView()
    }
  }
}
