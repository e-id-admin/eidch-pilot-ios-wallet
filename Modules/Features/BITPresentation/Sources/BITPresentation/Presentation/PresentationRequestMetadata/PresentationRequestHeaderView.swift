import BITTheming
import Foundation
import SDWebImageSwiftUI
import SwiftUI

// MARK: - PresentationRequestHeaderView

public struct PresentationRequestHeaderView: View {

  // MARK: Lifecycle

  init(verifier: Verifier?) {
    self.verifier = verifier
  }

  // MARK: Public

  public var body: some View {
    HStack(alignment: .top, spacing: .x3) {
      if let logoUri = verifier?.logoUri {
        WebImage(url: logoUri)
          .resizable()
          .placeholder {
            Rectangle().foregroundColor(.gray)
          }
          .aspectRatio(contentMode: .fill)
          .frame(width: 50, height: 50)
          .padding(.x1)
          .background(ThemingAssets.gray4.swiftUIColor)
          .clipShape(Circle())
      }

      if let name = verifier?.clientName {
        VStack(alignment: .leading, spacing: 0) {
          Text(name)
            .tracking(-0.5)
            .font(.custom.headline)
          Text(L10n.presentationVerifierText)
            .tracking(-0.1)
            .lineSpacing(-2)
            .lineLimit(2)
        }
      }

      Spacer()
    }
  }

  // MARK: Private

  private var verifier: Verifier?

}
