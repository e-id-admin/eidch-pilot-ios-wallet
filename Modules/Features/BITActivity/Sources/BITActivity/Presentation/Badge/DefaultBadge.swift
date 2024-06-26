import BITTheming
import Foundation
import SwiftUI

public struct DefaultBadge: View {

  // MARK: Lifecycle

  public init(systemName: String, color: Color, size: CGFloat = .x8) {
    self.systemName = systemName
    self.color = color
    self.size = size
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Image(systemName: systemName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 12, height: 12)
        .font(.custom.headline)
    }
    .frame(width: size, height: size)
    .background(ThemingAssets.gray4.swiftUIColor)
    .clipShape(Circle())
    .foregroundStyle(color)
  }

  // MARK: Private

  private let systemName: String
  private let color: Color
  private let size: CGFloat
}
