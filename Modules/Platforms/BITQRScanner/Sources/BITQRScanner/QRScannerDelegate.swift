import Foundation
import UIKit

// MARK: - QRScannerDelegate

public protocol QRScannerDelegate {

  func scannerViewDidFail(_ error: Error)

  func didFindQRCode(withMetadata string: String)
  func didReceiveImage(_ image: UIImage)
  func didReceiveError(_ error: Error)
  func didReceiveTorchAvailabilityUpdate(_ isAvailable: Bool)

}

extension QRScannerDelegate {

  public func didReceiveImage(_ image: UIImage) {}
  public func didReceiveImageWithError(_ error: Error) {}

}
