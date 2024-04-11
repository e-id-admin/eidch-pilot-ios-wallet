import BITTheming
import SwiftUI

struct NoCredentialsEmptyStateView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .x3) {
      Text(L10n.homeEmptyViewNoCredentialsTitle)
        .font(.custom.title)

      HomeAssets.home.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 300)

      Text(L10n.homeEmptyViewNoCredentialsIntroText)

      if let infoURL = URL(string: L10n.homeEmptyViewNoCredentialsMoreInfoLink) {
        Link(destination: infoURL, label: {
          LinkText(L10n.homeEmptyViewNoCredentialsMoreInfoText)
        })
      }

      Text(L10n.homeEmptyViewNoCredentialsScanText)

      if let scanURL = URL(string: L10n.homeEmptyViewNoCredentialsScanLink) {
        Link(destination: scanURL, label: {
          LinkText(L10n.homeEmptyViewNoCredentialsQrCodeText)
        })
      }

      Spacer(minLength: .x15)
    }
    .padding(.x4)
  }
}

#Preview {
  NoCredentialsEmptyStateView()
}
