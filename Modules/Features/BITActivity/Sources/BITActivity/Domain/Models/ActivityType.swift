import BITTheming
import Foundation
import SwiftUI

// MARK: - ActivityType

public enum ActivityType: String, Codable {
  case credentialReceived
  case presentationAccepted
  case presentationDeclined
}

extension ActivityType {
  public var description: String {
    switch self {
    case .credentialReceived: L10n.activitiesItemSubtitleCredentialReceived
    case .presentationAccepted: L10n.activitiesItemSubtitlePresentationAccepted
    case .presentationDeclined: L10n.activitiesItemSubtitlePresentationDeclined
    }
  }

  public var icon: String {
    switch self {
    case .credentialReceived: "plus"
    case .presentationAccepted: "checkmark"
    case .presentationDeclined: "multiply"
    }
  }

  public var iconColor: Color {
    switch self {
    case .credentialReceived,
         .presentationAccepted: ThemingAssets.green2.swiftUIColor
    case .presentationDeclined: ThemingAssets.red.swiftUIColor
    }
  }

  public var canNavigate: Bool {
    self != .credentialReceived
  }
}
