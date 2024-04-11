import BITTheming
import SwiftUI

// MARK: - PoliceQRCodeViewError

enum PoliceQRCodeViewError: Error {
  case invalidBase64Image
}

// MARK: - PoliceQRCodeView

public struct PoliceQRCodeView: View {

  // MARK: Lifecycle

  init(qrCodeData: Data) {
    self.qrCodeData = qrCodeData
  }

  init(qrCodeString: String) throws {
    guard let data = Data(base64URLEncoded: qrCodeString) else {
      throw PoliceQRCodeViewError.invalidBase64Image
    }

    qrCodeData = data
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x6) {
        Text(L10n.policeControlQrcodeScanText)
          .font(.custom.title)
          .foregroundColor(ThemingAssets.gray.swiftUIColor)

        ZStack {
          ThemingAssets.gray5.swiftUIColor
          Image(data: qrCodeData)?
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.x15)
        }
        .frame(maxWidth: .infinity, maxHeight: Defaults.qrCodeFrameMaxHeight)
        .cornerRadius(Defaults.qrCodeFrameRadius)

        Text(L10n.policeControlDescriptionText)
          .font(.custom.body)
          .foregroundColor(ThemingAssets.gray.swiftUIColor)

        Spacer()
      }
    }
    .padding(.horizontal, .x5)
    .padding(.top, .x4)
    .navigationTitle(L10n.policeControlTitle)
    .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Internal

  enum Defaults {
    static let qrCodeFrameMaxHeight: CGFloat = 350
    static let qrCodeFrameRadius: CGFloat = 6
  }

  // MARK: Private

  private let qrCodeData: Data
}
