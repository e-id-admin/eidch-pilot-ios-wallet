import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialList

public struct CredentialList: View {

  // MARK: Lifecycle

  public init(credentials: [Credential] = []) {
    self.credentials = credentials
  }

  // MARK: Public

  public var body: some View {
    ForEach(credentials) { credential in
      NavigationLink {
        CredentialDetailView(credential: credential)
      } label: {
        CredentialCard(credential)
      }
    }
  }

  // MARK: Internal

  var credentials: [Credential] = []

}
