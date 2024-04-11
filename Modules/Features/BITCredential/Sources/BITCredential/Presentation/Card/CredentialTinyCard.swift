import BITCore
import BITTheming
import SwiftUI

// MARK: - CredentialTinyCard

public struct CredentialTinyCard: View {

  // MARK: Lifecycle

  public init(_ credential: Credential) {
    self.credential = credential
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .top) {
      Color.clear
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, minHeight: Defaults.cardHeight, maxHeight: Defaults.cardHeight)
        .background(Color(hex: credential.preferredDisplay?.backgroundColor ?? ThemingAssets.accentColor.swiftUIColor.hexString()))
        .overlay(
          LinearGradient(gradient: Gradient(colors: Defaults.gradientMaskColors), startPoint: Defaults.gradientMaskStartPoint, endPoint: Defaults.gradientMaskEndPoint)
        )
        .overlay(
          RoundedRectangle(cornerRadius: Defaults.cornerRadius)
            .stroke(LinearGradient(gradient: Gradient(colors: Defaults.borderGradientColors), startPoint: Defaults.borderGradientStartPoint, endPoint: Defaults.borderGradientEndPoint), lineWidth: Defaults.borderLineWidth))
        .overlay(
          VStack(alignment: .leading) {
            Spacer()
            HStack(alignment: .bottom) {
              VStack(alignment: .leading, spacing: 0) {
                Text(credential.preferredDisplay?.name ?? "n/a")
                  .font(.custom.title2)
                  .tracking(-0.5)
                  .lineLimit(1)
                if let summary = credential.preferredDisplay?.summary {
                  Text(summary)
                    .font(.custom.subheadline)
                    .tracking(-0.5)
                    .lineLimit(1)
                }
              }

              Spacer()

              CredentialStatusBadge(status: credential.status)
            }
          }
          .foregroundColor(Color(hex: credential.preferredDisplay?.textColor ?? Color.white.hexString()) ?? .white)
          .padding(Defaults.padding)
          .padding(.bottom, .x2)
        )
        .clipShape(.rect(cornerRadius: Defaults.cornerRadius, style: .continuous))
        .padding(.horizontal, Defaults.outsidePadding)
        .shadow(color: Defaults.shadowColor, radius: Defaults.shadowRadius, x: Defaults.shadowX, y: Defaults.shadowY)

      Rectangle()
        .overlay(
          EdgeBorder(edges: [.bottom])
            .foregroundColor(ThemingAssets.gray3.swiftUIColor))
        .frame(height: Defaults.cornerRadius)
        .foregroundColor(ThemingAssets.background.swiftUIColor)
    }
  }

  // MARK: Internal

  enum Defaults {
    static let cardHeight: CGFloat = 80
    static let padding: CGFloat = .x4
    static let outsidePadding: CGFloat = .x3

    static let imageSize: CGFloat = 28
    static let cornerRadius: CGFloat = 6
    static let shadowColor: Color = .black.opacity(0.25)
    static let shadowRadius: CGFloat = 3
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 4

    static let gradientMaskColors: [Color] = [.black.opacity(0.125), .black.opacity(0)]
    static let gradientMaskStartPoint: UnitPoint = .top
    static let gradientMaskEndPoint: UnitPoint = .bottom

    static let borderLineWidth: CGFloat = 2
    static let borderGradientColors: [Color] = [Color.white.opacity(0.4), Color.black.opacity(0.1)]
    static let borderGradientStartPoint: UnitPoint = .topLeading
    static let borderGradientEndPoint: UnitPoint = .bottomTrailing
  }

  // MARK: Private

  private var credential: Credential

}
