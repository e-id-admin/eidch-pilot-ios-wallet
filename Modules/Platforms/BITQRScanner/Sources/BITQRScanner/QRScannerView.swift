import Foundation
import OSLog
import SwiftUI

// MARK: - QRScannerView

public struct QRScannerView: UIViewControllerRepresentable {

  // MARK: Lifecycle

  public init(configuration: QRScannerConfigurable? = nil, metadataUrl: Binding<URL?>, isTorchAvailable: Binding<Bool>, isTorchEnabled: Binding<Bool>, qrScannerError: Binding<Error?>) {
    self.configuration = configuration
    _metadataUrl = metadataUrl
    _isTorchAvailable = isTorchAvailable
    _isTorchEnabled = isTorchEnabled
    _qrScannerError = qrScannerError
  }

  // MARK: Public

  public static func dismantleUIViewController(_ uiViewController: QRScannerViewController, coordinator: ()) {
    uiViewController.stop()
    uiViewController.toggleTorch(to: false)
  }

  public func makeUIViewController(context: Context) -> QRScannerViewController {
    let controller = if let configuration {
      QRScannerViewController(configuration: configuration)
    } else {
      QRScannerViewController()
    }

    do {
      try controller.configure()
    } catch {
      qrScannerError = error
    }

    controller.delegate = self
    return controller
  }

  public func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
    if isTorchAvailable {
      uiViewController.toggleTorch(to: isTorchEnabled)
    }
  }

  // MARK: Internal

  var configuration: QRScannerConfigurable?

  @Binding var isTorchAvailable: Bool
  @Binding var isTorchEnabled: Bool
  @Binding var metadataUrl: URL?
  @Binding var qrScannerError: Error?

  // MARK: Private

}

// MARK: QRScannerDelegate

extension QRScannerView: QRScannerDelegate {

  public func scannerViewDidFail(_ error: Error) {
    guard let error = error as? QRScannerError else { return }
    qrScannerError = error
  }

  public func didFindQRCode(withMetadata string: String) {
    guard let url = URL(string: string) else { return }
    metadataUrl = url
  }

  public func didReceiveError(_ error: Error) {
    qrScannerError = error
  }

  public func didReceiveTorchAvailabilityUpdate(_ isAvailable: Bool) {
    isTorchAvailable = isAvailable
  }

}
