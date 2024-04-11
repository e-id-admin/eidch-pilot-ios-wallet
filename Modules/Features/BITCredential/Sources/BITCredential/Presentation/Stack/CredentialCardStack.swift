import BITTheming
import SwiftUI

// MARK: - CredentialCardStack

public struct CredentialCardStack: View {

  // MARK: Lifecycle

  public init(credentials: [Credential] = []) {
    self.credentials = credentials
  }

  // MARK: Public

  public var body: some View {
    VStack(spacing: 0) {
      ForEach(credentials) { credential in
        let index = indexOf(credential)

        VStack {
          NavigationLink {
            CredentialDetailView(credential: credential)
          } label: {
            CredentialCard(credential, position: index, maximumPosition: credentials.count)
          }
          .buttonStyle(.flatLink)
        }
        .offset(y: CGFloat(index) * -CredentialCard.Defaults.cardHeight)
        .offset(y: CGFloat(index) * Defaults.cardPreviewHeight)
      }
    }
    .padding(.bottom, CGFloat(credentials.count - 1) * -(CredentialCard.Defaults.cardHeight - Defaults.cardPreviewHeight))
  }

  // MARK: Internal

  enum Defaults {
    static let cardPreviewHeight: CGFloat = 60
  }

  // MARK: Private

  private var credentials: [Credential] = []

  private func indexOf(_ credential: Credential) -> Int {
    credentials.firstIndex { credential == $0 } ?? 0
  }

}
