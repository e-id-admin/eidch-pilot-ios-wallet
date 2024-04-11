import AVFoundation
import Foundation
import SwiftUI
import UIKit

// MARK: - QRScannerViewController

public class QRScannerViewController: UIViewController {

  // MARK: Lifecycle

  public init(
    delegate: QRScannerDelegate? = nil,
    videoOutputSettings: [String: Any] = Defaults.videoOutputSettings,
    scannerTimeoutInterval: TimeInterval = Defaults.scannerTimeoutInterval,
    isVideoOutputEnabled: Bool = Defaults.isVideoOutputEnabled,
    isMetadataOutputEnabled: Bool = Defaults.isMetadataOutputEnabled,
    isBreathingAnimationEnabled: Bool = Defaults.isBreathingAnimationEnabled,
    breathingAnimationDuration: TimeInterval = Defaults.breathingAnimationDuration,
    breathingAnimationDelay: TimeInterval = Defaults.breathingAnimationDelay,
    breathingAnimationScaleX: CGFloat = Defaults.breathingAnimationScaleX,
    breathingAnimationScaleY: CGFloat = Defaults.breathingAnimationScaleY,
    movingAnimationDuration: TimeInterval = Defaults.movingAnimationDuration,
    focusAreaInitialPosition: CGRect = Defaults.focusAreaInitialPosition,
    focusAreaImage: UIImage = Defaults.focusAreaImage,
    focusAreaWidthThreshold: CGFloat = Defaults.focusAreaWidthThreshold,
    focusAreaPadding: CGFloat = Defaults.focusAreaPadding,
    metadataScannerType: [AVMetadataObject.ObjectType] = Defaults.metadataScannerType)
  {
    self.delegate = delegate
    self.videoOutputSettings = videoOutputSettings
    self.scannerTimeoutInterval = scannerTimeoutInterval
    self.isVideoOutputEnabled = isVideoOutputEnabled
    self.isBreathingAnimationEnabled = isBreathingAnimationEnabled
    self.isMetadataOutputEnabled = isMetadataOutputEnabled
    self.breathingAnimationDuration = breathingAnimationDuration
    self.breathingAnimationDelay = breathingAnimationDelay
    self.breathingAnimationScaleX = breathingAnimationScaleX
    self.breathingAnimationScaleY = breathingAnimationScaleY
    self.movingAnimationDuration = movingAnimationDuration
    self.focusAreaInitialPosition = focusAreaInitialPosition
    self.focusAreaImage = focusAreaImage
    self.focusAreaWidthThreshold = focusAreaWidthThreshold
    self.focusAreaPadding = focusAreaPadding
    self.metadataScannerType = metadataScannerType

    super.init(nibName: nil, bundle: nil)
  }

  public init(configuration: QRScannerConfigurable, delegate: QRScannerDelegate? = nil) {
    videoOutputSettings = configuration.videoOutputSettings
    scannerTimeoutInterval = configuration.scannerTimeoutInterval
    isVideoOutputEnabled = configuration.isVideoOutputEnabled
    isBreathingAnimationEnabled = configuration.isBreathingAnimationEnabled
    isMetadataOutputEnabled = configuration.isMetadataOutputEnabled
    breathingAnimationDuration = configuration.breathingAnimationDuration
    breathingAnimationDelay = configuration.breathingAnimationDelay
    breathingAnimationScaleX = configuration.breathingAnimationScaleX
    breathingAnimationScaleY = configuration.breathingAnimationScaleY
    movingAnimationDuration = configuration.movingAnimationDuration
    focusAreaInitialPosition = configuration.focusAreaInitialPosition
    focusAreaImage = configuration.focusAreaImage
    focusAreaWidthThreshold = configuration.focusAreaWidthThreshold
    focusAreaPadding = configuration.focusAreaPadding
    metadataScannerType = configuration.metadataScannerType

    self.delegate = delegate

    super.init(nibName: nil, bundle: nil)
  }

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    fatalError("Not implemented...")
  }

  // MARK: Public

  public enum Defaults {
    public static let videoOutputSettings: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]

    public static let isVideoOutputEnabled: Bool = true
    public static let isMetadataOutputEnabled: Bool = true
    public static let isBreathingAnimationEnabled: Bool = true

    public static let scannerTimeoutInterval: TimeInterval = 0.5

    public static let breathingAnimationDuration: TimeInterval = 0.550
    public static let breathingAnimationDelay: TimeInterval = 0
    public static let breathingAnimationOptions: UIView.AnimationOptions = [.repeat, .autoreverse]
    public static let breathingAnimationScaleX: CGFloat = 1.015
    public static let breathingAnimationScaleY: CGFloat = 1.015

    public static let movingAnimationDuration: TimeInterval = 0.350

    public static let focusAreaWidthThreshold: CGFloat = 0.5
    public static let focusAreaInitialPosition: CGRect = .init(
      x: UIScreen.main.bounds.width / 2 - (UIScreen.main.bounds.width * Defaults.focusAreaWidthThreshold) / 2,
      y: 150,
      width: UIScreen.main.bounds.width * Defaults.focusAreaWidthThreshold,
      height: UIScreen.main.bounds.width * Defaults.focusAreaWidthThreshold)
    public static let focusAreaImage: UIImage = Assets.scanner.image
    public static let focusAreaPadding: CGFloat = 8

    public static let metadataScannerType: [AVMetadataObject.ObjectType] = [.qr]
  }

  public var delegate: QRScannerDelegate?

  public var videoOutputSettings: [String: Any] = Defaults.videoOutputSettings
  public var isVideoOutputEnabled: Bool = Defaults.isVideoOutputEnabled

  public var isBreathingAnimationEnabled: Bool = Defaults.isBreathingAnimationEnabled
  public var breathingAnimationDuration: TimeInterval = Defaults.breathingAnimationDuration
  public var breathingAnimationDelay: TimeInterval = Defaults.breathingAnimationDelay
  public var breathingAnimationScaleX: CGFloat = Defaults.breathingAnimationScaleX
  public var breathingAnimationScaleY: CGFloat = Defaults.breathingAnimationScaleY

  public var movingAnimationDuration: TimeInterval = Defaults.movingAnimationDuration

  public var focusAreaInitialPosition: CGRect = Defaults.focusAreaInitialPosition
  public var focusAreaImage: UIImage = Defaults.focusAreaImage
  public var focusAreaWidthThreshold: CGFloat = Defaults.focusAreaWidthThreshold
  public var focusAreaPadding: CGFloat = Defaults.focusAreaPadding

  public var metadataScannerType: [AVMetadataObject.ObjectType] = Defaults.metadataScannerType
  public var isMetadataOutputEnabled: Bool = Defaults.isMetadataOutputEnabled

  public var isTorchAvailable: Bool {
    assert(Thread.isMainThread)
    guard let videoDevice = AVCaptureDevice.default(for: .video) else { return false }
    return videoDevice.hasTorch && videoDevice.isTorchAvailable && (isMetadataOutputEnabled || isVideoOutputEnabled)
  }

  public func toggleTorch(to value: Bool) {
    guard let videoDevice = AVCaptureDevice.default(for: .video), isTorchAvailable else { return }
    try? videoDevice.lockForConfiguration()
    videoDevice.torchMode = value ? .on : .off
    videoDevice.unlockForConfiguration()
  }

  public func start() {
    guard
      CameraPermissionStatus.isCameraPermissionAuthorized,
      !session.isRunning
    else { return }
    configurePreviewLayer()
    configureTimer()
    metadataQueue.async { [weak self] in
      self?.session.startRunning()
    }
  }

  public func stop() {
    guard session.isRunning else { return }
    scannerTimer?.invalidate()
    videoQueue.async { [weak self] in
      self?.session.stopRunning()
    }
    isVideoOutputEnabled = false
    isMetadataOutputEnabled = false
  }

  public func restart() throws {
    guard CameraPermissionStatus.isCameraPermissionAuthorized else { return }
    focusAreaImageView.removeFromSuperview()

    configureTimer()
    resetFocusAreaPosition()

    isVideoOutputEnabled = Defaults.isVideoOutputEnabled
    isMetadataOutputEnabled = Defaults.isMetadataOutputEnabled
  }

  public func configure() throws {
    try configureCameraInput()
    configurePreviewLayer()
    configureMetadataOutput()
    configureVideoOutput()
    start()

    configureLayout()
    configureAnimations()

    handlePermissionCheck()

    delegate?.didReceiveTorchAvailabilityUpdate(isTorchAvailable)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    delegate?.didReceiveTorchAvailabilityUpdate(isTorchAvailable)
  }

  // MARK: Internal

  typealias Triangle = (a: CGFloat, b: CGFloat, c: CGFloat)

  var lastScannedItemDate: Date?
  var scannerTimeoutInterval: TimeInterval = Defaults.scannerTimeoutInterval
  var scannerTimer: Timer?

  let session = AVCaptureSession()

  let videoOutput = AVCaptureVideoDataOutput()
  let metadataOutput = AVCaptureMetadataOutput()

  let videoQueue = DispatchQueue(label: "qrreader.video.queue")
  let metadataQueue = DispatchQueue(label: "qrreader.metadata.queue")

  lazy var preview: AVCaptureVideoPreviewLayer = {
    let preview = AVCaptureVideoPreviewLayer(session: session)
    preview.videoGravity = .resizeAspectFill
    return preview
  }()

  var focusAreaImageView: UIImageView = .init()

  // MARK: Private

  private func handlePermissionCheck() {
    switch CameraPermissionStatus.cameraPermissionStatus {
    case .authorized:
      return
    case .restricted:
      delegate?.scannerViewDidFail(QRScannerError.notAuthorized(.restricted))
    case .denied:
      delegate?.scannerViewDidFail(QRScannerError.notAuthorized(.denied))
    case .notDetermined:
      isVideoOutputEnabled = false
      isMetadataOutputEnabled = true
      metadataQueue.async { [weak self] in
        self?.session.startRunning()
      }
      delegate?.scannerViewDidFail(QRScannerError.notAuthorized(.notDetermined))
    }
  }

  private func configureTimer() {
    scannerTimer = Timer.scheduledTimer(withTimeInterval: scannerTimeoutInterval, repeats: true) { [weak self] _ in
      guard
        let self,
        let lastScannedItemDate,
        Date().timeIntervalSince(lastScannedItemDate) > scannerTimeoutInterval else { return }
      resetFocusAreaPosition()
    }
  }

  private func configureCameraInput() throws {
    guard let device = AVCaptureDevice.default(for: .video) else { throw QRScannerError.captureDeviceNotAvailable }
    let input = try AVCaptureDeviceInput(device: device)
    session.addInput(input)
  }

  private func configureVideoOutput() {
    videoOutput.videoSettings = videoOutputSettings
    videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
    session.addOutput(videoOutput)
  }

  private func configureMetadataOutput() {
    metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
    session.addOutput(metadataOutput)
    metadataOutput.metadataObjectTypes = metadataScannerType
  }

  private func configurePreviewLayer() {
    preview.frame = view.bounds
    view.layer.addSublayer(preview)
  }

  private func configureLayout() {
    let imageView = UIImageView(frame: focusAreaInitialPosition)
    imageView.image = focusAreaImage
    imageView.contentMode = .scaleAspectFill

    focusAreaImageView = imageView
    view.addSubview(focusAreaImageView)
  }

  private func configureAnimations() {
    if isBreathingAnimationEnabled {
      UIView.animate(withDuration: breathingAnimationDuration, delay: breathingAnimationDelay, options: [.repeat, .autoreverse], animations: { [weak self] in
        guard let self else { return }
        focusAreaImageView.transform = CGAffineTransform(scaleX: breathingAnimationScaleX, y: breathingAnimationScaleY)
      }, completion: nil)
    }
  }

  private func resetFocusAreaPosition() {
    lastScannedItemDate = nil
    UIView.animate(withDuration: movingAnimationDuration) { [weak self] in
      guard let self else { return }
      focusAreaImageView.frame = Defaults.focusAreaInitialPosition
      focusAreaImageView.transform = CGAffineTransform.identity
    } completion: { [weak self] _ in
      guard let self else { return }
      configureAnimations()
    }
  }

}
