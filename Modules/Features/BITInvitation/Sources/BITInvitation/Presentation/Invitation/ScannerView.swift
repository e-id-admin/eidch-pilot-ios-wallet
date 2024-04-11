import BITQRScanner
import BITTheming
import Foundation
import SwiftUI

public struct ScannerView: View {

  // MARK: Lifecycle

  public init(
    metadataUrl: Binding<URL?>,
    isTorchAvailable: Binding<Bool> = .constant(true),
    isTorchEnabled: Binding<Bool> = .constant(false),
    error: Binding<Error?>,
    isTipPresented: Bool = true)
  {
    _metadataUrl = metadataUrl
    _isTorchEnabled = isTorchEnabled
    _isTorchAvailable = isTorchAvailable
    _error = error
    _isTipPresented.wrappedValue = isTipPresented
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .bottom) {
      QRScannerView(metadataUrl: $metadataUrl, isTorchAvailable: $isTorchAvailable, isTorchEnabled: $isTorchEnabled, qrScannerError: $error)

      VStack(spacing: 0) {
        Button(action: {
          withAnimation {
            isTorchEnabled.toggle()
          }
        }, label: {
          Label(
            title: { Text(isTorchEnabled ? L10n.qrScannerFlashLightButtonOff : L10n.qrScannerFlashLightButtonOn) },
            icon: { Image(systemName: isTorchEnabled ? "lightbulb.slash" : "lightbulb") })
        })
        .buttonStyle(.primaryReversed)
        .padding(.bottom, .x10)
        .opacity(isTorchAvailable ? 1.0 : 0.0)
        .animation(.easeInOut, value: isTorchAvailable)

        if isTipPresented {
          HStack(spacing: .x1) {
            Text(L10n.qrScannerHint)
              .font(.custom.subheadline)

            Spacer()

            Button(action: {
              withAnimation {
                isTipPresented.toggle()
              }
            }, label: {
              Image(systemName: "xmark.circle.fill")
                .resizable()
                .accessibilityLabel(L10n.qrScannerHintCloseButton)
                .frame(width: 20, height: 20)
            })
            .foregroundColor(ThemingAssets.gray.swiftUIColor)
          }
          .padding()
          .background(ThemingAssets.background.swiftUIColor.ignoresSafeArea())
        }
      }
    }
  }

  // MARK: Private

  @State private var isTipPresented: Bool = true

  @Binding private var metadataUrl: URL?
  @Binding private var isTorchEnabled: Bool
  @Binding private var isTorchAvailable: Bool
  @Binding private var error: Error?

}
