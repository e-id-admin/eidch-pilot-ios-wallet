import Foundation

public enum QRScannerError: Error {
  case captureDeviceNotAvailable
  case cannotCreateCGImage
  case cannotGetImageBuffer
  case missingScreenScale
  case missingSelf

  case notAuthorized(CameraPermissionStatus)
}
