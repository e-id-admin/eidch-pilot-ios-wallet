import BITTheming
import SwiftUI

public struct CredentialStatusLabel: View {

  // MARK: Lifecycle

  public init(status: CredentialStatus) {
    self.status = status
  }

  // MARK: Public

  public var body: some View {
    VStack {
      switch status {
      case .valid:
        Label(L10n.credentialStatusValid, systemImage: "checkmark")
          .labelStyle(.standardStatus)
      case .invalid:
        Label(L10n.credentialStatusInvalid, systemImage: "slash.circle")
          .labelStyle(.errorStatus)
      case .unknown:
        EmptyView()
      }
    }
  }

  // MARK: Private

  private var status: CredentialStatus

}
