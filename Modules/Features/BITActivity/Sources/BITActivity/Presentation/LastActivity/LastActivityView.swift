import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - LastActivityView

public struct LastActivityView: View {

  // MARK: Lifecycle

  public init(_ activity: Activity, onTapActivity: @escaping () -> Void, onTapHeader: @escaping () -> Void) {
    viewModel = Container.shared.activityCellViewModel(activity)
    self.onTapActivity = onTapActivity
    self.onTapHeader = onTapHeader
  }

  // MARK: Public

  public var body: some View {
    VStack {
      HStack {
        Text(L10n.homeLastActivityHeaderText)
          .font(.custom.headline)
          .foregroundStyle(ThemingAssets.secondary.swiftUIColor)

        Spacer()

        Button(action: onTapHeader, label: {
          Text(L10n.homeLastActivityHeaderButton)
            .underline()
            .foregroundStyle(ThemingAssets.accentColor.swiftUIColor)
            .font(.custom.textLink)
        })
      }

      Button(action: onTapActivity, label: {
        ActivityCellView(viewModel.activity)
          .padding(.x4)
          .border(ThemingAssets.gray5.swiftUIColor, width: 1)
          .contentShape(Rectangle())
      })
      .buttonStyle(.flatLink)
    }
  }

  // MARK: Private

  private var onTapActivity: () -> Void
  private var onTapHeader: () -> Void
  private let viewModel: ActivityCellViewModel
}
