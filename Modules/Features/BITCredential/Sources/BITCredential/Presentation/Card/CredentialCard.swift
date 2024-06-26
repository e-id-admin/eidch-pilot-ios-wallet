import BITCore
import BITCredentialShared
import BITTheming
import SDWebImageSwiftUI
import SwiftUI

// MARK: - CredentialCard

public struct CredentialCard: View {

  // MARK: Lifecycle

  public init(_ credential: Credential, position: Int = 0, maximumPosition: Int = Defaults.maximumPosition) {
    self.credential = credential
    self.maximumPosition = maximumPosition < Defaults.maximumPosition ? maximumPosition + 1 : Defaults.maximumPosition
    self.position = position >= self.maximumPosition ? self.maximumPosition - 1 : position
  }

  // MARK: Public

  public var body: some View {
    Color.clear
      .foregroundColor(.white)
      .padding()
      .frame(maxWidth: .infinity, minHeight: Defaults.cardHeight, maxHeight: Defaults.cardHeight)
      .background(Color(hex: credential.preferredDisplay?.backgroundColor ?? ThemingAssets.accentColor.swiftUIColor.hexString()))
      .overlay(
        LinearGradient(gradient: Gradient(colors: Defaults.gradientMaskColors(position: position, maximumPosition: maximumPosition)), startPoint: Defaults.gradientMaskStartPoint, endPoint: Defaults.gradientMaskEndPoint)
      )
      .overlay(
        RoundedRectangle(cornerRadius: Defaults.cornerRadius)
          .stroke(LinearGradient(gradient: Gradient(colors: Defaults.borderGradientColors), startPoint: Defaults.borderGradientStartPoint, endPoint: Defaults.borderGradientEndPoint), lineWidth: Defaults.borderLineWidth))
      .overlay(
        VStack(alignment: .leading) {
          if let base64Image = credential.preferredDisplay?.logoBase64 {
            Image(data: base64Image)?
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: Defaults.imageSize, height: Defaults.imageSize)
          }
          Spacer()
          HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
              Text(credential.preferredDisplay?.name ?? L10n.globalNotAssigned)
                .font(.custom.title2)
                .tracking(Defaults.characterSpacing)
                .lineLimit(1)
              if let summary = credential.preferredDisplay?.summary {
                Text(summary)
                  .font(.custom.subheadline)
                  .tracking(Defaults.characterSpacing)
                  .lineLimit(1)
              }
            }

            Spacer()

            CredentialStatusBadge(status: credential.status)
          }
        }
        .foregroundColor(Color(hex: credential.preferredDisplay?.textColor ?? Color.white.hexString()) ?? .white)
        .padding(.horizontal, Defaults.horizontalPadding)
        .padding(.vertical, Defaults.verticalPadding)
      )
      .clipShape(.rect(cornerRadius: Defaults.cornerRadius, style: .continuous))
      .shadow(color: Defaults.shadowColor, radius: Defaults.shadowRadius, x: Defaults.shadowX, y: Defaults.shadowY)
  }

  // MARK: Private

  private var credential: Credential
  private let position: Int
  private let maximumPosition: Int

}

// MARK: CredentialCard.Defaults

extension CredentialCard {

  public enum Defaults {

    // MARK: Public

    public static let maximumPosition: Int = 4

    // MARK: Internal

    static let cardHeight: CGFloat = 220
    static let verticalPadding: CGFloat = .x5
    static let horizontalPadding: CGFloat = .x4

    static let characterSpacing: CGFloat = -0.5

    static let imageSize: CGFloat = 28
    static let cornerRadius: CGFloat = 6
    static let shadowColor: Color = .black.opacity(0.25)
    static let shadowRadius: CGFloat = 8
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 4

    static let gradientMaskStartPoint: UnitPoint = .top
    static let gradientMaskEndPoint: UnitPoint = .bottom

    static let borderLineWidth: CGFloat = 2
    static let borderGradientColors: [Color] = [Color.white.opacity(0.4), Color.black.opacity(0.1)]
    static let borderGradientStartPoint: UnitPoint = .topLeading
    static let borderGradientEndPoint: UnitPoint = .bottomTrailing

    static func gradientMaskColors(position: Int, maximumPosition: Int) -> [Color] {
      [.black.opacity(CGFloat((maximumPosition - 1) - position) / CGFloat(Defaults.maximumPosition)), .black.opacity(0)]
    }
  }
}
