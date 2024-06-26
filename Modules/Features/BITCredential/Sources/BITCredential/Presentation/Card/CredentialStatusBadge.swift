import BITCredentialShared
import BITTheming
import SwiftUI

public struct CredentialStatusBadge: View {

  // MARK: Lifecycle

  public init(status: CredentialStatus) {
    self.status = status
  }

  // MARK: Public

  public var body: some View {
    VStack {
      switch status {
      case .valid:
        Badge { Label(L10n.credentialStatusValid, systemImage: "checkmark") }
          .badgeStyle(.standard)
      case .invalid:
        Badge { Label(L10n.credentialStatusInvalid, systemImage: "slash.circle") }
          .badgeStyle(.error)
      case .unknown:
        Badge { Label(L10n.credentialStatusUnknown, systemImage: "slash.circle") }
          .badgeStyle(.outline)
      }
    }
  }

  // MARK: Private

  private var status: CredentialStatus

}
