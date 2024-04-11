import AVFoundation
import BITCore
import Combine
import Foundation
import UIKit

class CameraPermissionViewModel: StateMachine<AVAuthorizationStatus, CameraPermissionViewModel.Event> {

  // MARK: Lifecycle

  init(initialState: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video), _ completed: (() -> Void)? = nil) {
    super.init(initialState)

    self.completed = completed

    if initialState == .authorized {
      Task {
        await send(event: .didAllowCamera)
      }
    }
  }

  // MARK: Internal

  enum Event {
    case allowCamera
    case openSettings

    case didAllowCamera
    case setError(_ error: Error)

    case close
  }

  var completed: (() -> Void)?

  var isAuthorized: Bool {
    status == .authorized
  }

  var status: AVAuthorizationStatus {
    AVCaptureDevice.authorizationStatus(for: .video)
  }

  override func reducer(_ state: inout AVAuthorizationStatus, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (.denied, .openSettings),
         (.restricted, .openSettings):
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }

    case (.notDetermined, .allowCamera):
      return SendablePublisher {
        await AVCaptureDevice.requestAccess(for: .video)
      }
      .map { .didAllowCamera }
      .catch({ error -> Just<Event> in
        Just(.setError(error))
      }).eraseToAnyPublisher()

    case (_, .didAllowCamera):
      state = status
      if state == .authorized {
        completed?()
      }

    case (_, .close):
      completed?()

    default: break
    }

    return nil
  }

}
