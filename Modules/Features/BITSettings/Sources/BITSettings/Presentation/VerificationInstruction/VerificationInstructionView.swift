import BITTheming
import SwiftUI

struct VerificationInstructionView: View {
  enum Defaults {
    static let qrCodeFrameMaxHeight: CGFloat = 350
    static let qrCodeFrameRadius: CGFloat = .x2
    static let imageMaxFrame: CGFloat = 300
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: .x6) {
        Assets.verification.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: Defaults.imageMaxFrame)
          .padding(.top, .x4)

        Text(L10n.getVerifiedText)
          .font(.custom.body)
          .foregroundColor(ThemingAssets.gray.swiftUIColor)

        ZStack {
          ThemingAssets.gray5.swiftUIColor
          VStack(alignment: .leading, spacing: .x3) {
            Assets.verificationQrCode.swiftUIImage
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxHeight: Defaults.imageMaxFrame)

            if let url = URL(string: L10n.getVerifiedLink) {
              Link(destination: url, label: {
                LinkText(L10n.getVerifiedLinkText)
              })
            }

            Spacer()
          }
          .padding(.top, .x12)
        }
        .frame(maxWidth: .infinity, maxHeight: Defaults.qrCodeFrameMaxHeight)
        .cornerRadius(Defaults.qrCodeFrameRadius)

        Spacer()
      }
    }
    .padding(.horizontal, .x6)
    .navigationTitle(L10n.getVerifiedTitle)
    .navigationBackButtonDisplayMode(.minimal)
  }
}
