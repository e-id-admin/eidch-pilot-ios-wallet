import BITCore
import BITTheming
import SwiftUI

// MARK: - CredentialTinyCard

public struct CredentialThumbnailCard: View {

  // MARK: Lifecycle

  public init(_ credential: Credential) {
    self.credential = credential
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .top) {
      Color.clear
        .foregroundColor(.white)
        .frame(width: Defaults.cardWidth, height: Defaults.cardHeight)
        .background(Color(hex: credential.preferredDisplay?.backgroundColor ?? ThemingAssets.accentColor.swiftUIColor.hexString()))
        .overlay(
          LinearGradient(gradient: Gradient(colors: Defaults.gradientMaskColors), startPoint: Defaults.gradientMaskStartPoint, endPoint: Defaults.gradientMaskEndPoint)
        )
        .overlay(
          RoundedRectangle(cornerRadius: Defaults.cornerRadius)
            .stroke(LinearGradient(gradient: Gradient(colors: Defaults.borderGradientColors), startPoint: Defaults.borderGradientStartPoint, endPoint: Defaults.borderGradientEndPoint), lineWidth: Defaults.borderLineWidth))
        .overlay(
          VStack {
            if let base64Image = credential.preferredDisplay?.logoBase64 {
              Image(data: base64Image)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Defaults.imageSize, height: Defaults.imageSize)
            }
          }
          .foregroundColor(Color(hex: credential.preferredDisplay?.textColor ?? Color.white.hexString()) ?? .white)
        )
        .clipShape(.rect(cornerRadius: Defaults.cornerRadius, style: .continuous))
    }
  }

  // MARK: Internal

  enum Defaults {
    static let cardWidth: CGFloat = 72
    static let cardHeight: CGFloat = 96

    static let imageSize: CGFloat = 28
    static let cornerRadius: CGFloat = 6

    static let gradientMaskColors: [Color] = [.black.opacity(1.5 / 5.0), .black.opacity(0)]
    static let gradientMaskStartPoint: UnitPoint = .leading
    static let gradientMaskEndPoint: UnitPoint = .trailing

    static let borderLineWidth: CGFloat = 2
    static let borderGradientColors: [Color] = [Color.white.opacity(0.4), Color.black.opacity(0.1)]
    static let borderGradientStartPoint: UnitPoint = .topLeading
    static let borderGradientEndPoint: UnitPoint = .bottomTrailing
  }

  // MARK: Private

  private var credential: Credential

}
