import AVFoundation
import Foundation
import UIKit

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

  // MARK: Public

  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    guard
      isMetadataOutputEnabled,
      let metadataObject = metadataObjects.first,
      let object = preview.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject,
      metadataScannerType.contains(metadataObject.type)
    else { return }

    guard let stringOutput = object.stringValue else { return }

    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      focusAreaOnQrCode(at: object.corners) {
        self.lastScannedItemDate = Date()
        self.delegate?.didFindQRCode(withMetadata: stringOutput)
      }
    }
  }

  // MARK: Private

  private func focusAreaOnQrCode(at corners: [CGPoint], _ onCompletion: @escaping () -> Void) {
    assert(Thread.isMainThread)

    guard !corners.isEmpty else { return }
    let path = computeBezierPath(corners: corners)
    var sides = computeSides(corners: corners)
    sides.c += focusAreaPadding * 2
    let degrees = atan(sides.a / sides.b)

    UIView.animate(withDuration: movingAnimationDuration, animations: { [weak self] in
      guard let self else { return }
      focusAreaImageView.frame = path.bounds
      let center = focusAreaImageView.center
      focusAreaImageView.frame.size = CGSize(width: sides.c, height: sides.c)
      focusAreaImageView.center = center
      focusAreaImageView.transform = CGAffineTransform.identity.rotated(by: degrees)
    }, completion: { _ in
      onCompletion()
    })
  }

  private func computeSides(corners: [CGPoint]) -> Triangle {
    var sides: Triangle = (0, 0, 0)

    if corners[0].x < corners[1].x {
      sides.a = corners[0].x - corners[1].x
      sides.b = corners[1].y - corners[0].y
    } else {
      sides.a = corners[2].y - corners[1].y
      sides.b = corners[2].x - corners[1].x
    }

    sides.c = hypot(corners[3].x - corners[0].x, corners[3].y - corners[0].y)

    for (i, _) in corners.enumerated() where i < 3 {
      let side = hypot(corners[i].x - corners[i + 1].x, corners[i].y - corners[i + 1].y)
      sides.c = side > sides.c ? side : sides.c
    }

    return sides
  }

  private func computeBezierPath(corners: [CGPoint]) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: corners[0])
    for corner in corners[1..<corners.count] {
      path.addLine(to: corner)
    }
    path.close()
    return path
  }
}
