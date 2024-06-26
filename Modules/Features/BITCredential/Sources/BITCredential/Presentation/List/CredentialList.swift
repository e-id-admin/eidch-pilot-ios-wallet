import BITCredentialShared
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialList

public struct CredentialList: View {

  // MARK: Lifecycle

  public init(credentials: [Credential] = [], isPresented: Binding<Bool>) {
    self.credentials = credentials
    _isPresented = isPresented
  }

  // MARK: Public

  public var body: some View {
    ForEach(credentials) { credential in
      NavigationLink {
        CredentialDetailView(credential: credential, isPresented: $isPresented)
      } label: {
        CredentialCard(credential)
      }
    }
  }

  // MARK: Private

  private var credentials: [Credential] = []
  @Binding private var isPresented: Bool

}
