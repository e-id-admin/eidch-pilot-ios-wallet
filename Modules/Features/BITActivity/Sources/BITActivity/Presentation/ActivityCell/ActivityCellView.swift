import BITTheming
import Factory
import SwiftUI

// MARK: - ActivityListItem

public struct ActivityCellView: View {

  // MARK: Lifecycle

  public init(_ activity: Activity, badgeSize: CGFloat = .x8, canNavigate: Bool = true, onDelete: (() -> Void)? = nil) {
    self.badgeSize = badgeSize
    self.canNavigate = !canNavigate ? false : activity.type.canNavigate
    self.onDelete = onDelete
    viewModel = Container.shared.activityCellViewModel(activity)
  }

  // MARK: Public

  public var body: some View {
    HStack(spacing: .x4) {
      ActivityTypeBadge(activityType: viewModel.type, size: badgeSize)

      VStack(alignment: .leading) {
        Text(viewModel.verifierName)
          .font(.custom.headline2)
          .lineLimit(1)
        Text(viewModel.description)
          .font(.custom.body)
          .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
        Text(viewModel.formattedDate)
          .font(.custom.footnote2)
          .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
      }

      Spacer()

      if canNavigate {
        Image(systemName: "chevron.right")
      }
    }
    .if(onDelete != nil, transform: {
      $0.swipeActions(allowsFullSwipe: true) {
        Button(role: .destructive, action: {
          onDelete?()
        }, label: {
          Label(L10n.activitiesItemDeleteButton, systemImage: "trash")
            .foregroundStyle(.white, .white)
        })
      }
    })
  }

  // MARK: Private

  private let badgeSize: CGFloat
  private let canNavigate: Bool
  private var onDelete: (() -> Void)? = nil
  private var viewModel: ActivityCellViewModel
}
