import BITTheming
import Foundation
import SwiftUI

public struct ActivityTypeBadge: View {

  // MARK: Lifecycle

  public init(activityType: ActivityType, size: CGFloat = .x8) {
    self.activityType = activityType
    self.size = size
  }

  // MARK: Public

  public var body: some View {
    DefaultBadge(systemName: activityType.icon, color: activityType.iconColor, size: size)
  }

  // MARK: Private

  private let size: CGFloat
  private let activityType: ActivityType
}
