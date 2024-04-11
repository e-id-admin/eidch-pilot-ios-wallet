import AVFoundation
import Foundation
import UIKit

// MARK: - QRScannerConfigurable

public protocol QRScannerConfigurable {
  var videoOutputSettings: [String: Any] { get set }

  var scannerTimeoutInterval: TimeInterval { get set }

  var isVideoOutputEnabled: Bool { get set }
  var isBreathingAnimationEnabled: Bool { get set }
  var isMetadataOutputEnabled: Bool { get set }

  var breathingAnimationDuration: TimeInterval { get set }
  var breathingAnimationDelay: TimeInterval { get set }
  var breathingAnimationScaleX: CGFloat { get set }
  var breathingAnimationScaleY: CGFloat { get set }

  var movingAnimationDuration: TimeInterval { get set }

  var focusAreaInitialPosition: CGRect { get set }
  var focusAreaImage: UIImage { get set }
  var focusAreaWidthThreshold: CGFloat { get set }
  var focusAreaPadding: CGFloat { get set }

  var metadataScannerType: [AVMetadataObject.ObjectType] { get set }
}

// MARK: - QRScannerConfiguration

public struct QRScannerConfiguration: QRScannerConfigurable {
  public var videoOutputSettings: [String: Any]

  public var scannerTimeoutInterval: TimeInterval

  public var isVideoOutputEnabled: Bool
  public var isBreathingAnimationEnabled: Bool
  public var isMetadataOutputEnabled: Bool

  public var breathingAnimationDuration: TimeInterval
  public var breathingAnimationDelay: TimeInterval
  public var breathingAnimationScaleX: CGFloat
  public var breathingAnimationScaleY: CGFloat

  public var movingAnimationDuration: TimeInterval

  public var focusAreaInitialPosition: CGRect
  public var focusAreaImage: UIImage
  public var focusAreaWidthThreshold: CGFloat
  public var focusAreaPadding: CGFloat

  public var metadataScannerType: [AVMetadataObject.ObjectType]
}
