import AVFoundation
import Foundation
import OSLog
import UIKit

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension QRScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

  // MARK: Public

  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    connection.videoOrientation = .portrait

    guard isVideoOutputEnabled else { return }
    getUIImageFromSampleBuffer(sampleBuffer) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let image):
        delegate?.didReceiveImage(image)
      case .failure(let error):
        delegate?.didReceiveImageWithError(error)
      }
    }

  }

  // MARK: Private

  private func getUIImageFromSampleBuffer(_ imageBuffer: CMSampleBuffer, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let buffer = CMSampleBufferGetImageBuffer(imageBuffer) else { return completion(.failure(QRScannerError.cannotGetImageBuffer)) }

    CVPixelBufferLockBaseAddress(buffer, .readOnly)

    let address = CVPixelBufferGetBaseAddress(buffer)
    let width = CVPixelBufferGetWidth(buffer)
    let height = CVPixelBufferGetHeight(buffer)
    let bitsPerComponent = 8
    let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
    let space = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)

    guard
      let context = CGContext(data: address, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo.rawValue),
      let cgImage = context.makeImage()
    else {
      return completion(.failure(QRScannerError.cannotCreateCGImage))
    }

    CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return completion(.failure(QRScannerError.missingSelf))
      }
      guard let scale = view.window?.windowScene?.screen.scale else {
        return completion(.failure(QRScannerError.missingScreenScale))
      }

      let uiImage = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
      completion(.success(uiImage))
    }
  }

}
