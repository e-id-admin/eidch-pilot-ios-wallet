import BITCredentialShared
import BITTheming
import SwiftUI

// MARK: - CredentialCardStack

public struct CredentialCardStack: View {

  // MARK: Lifecycle

  public init(credentials: [Credential] = [], isPresented: Binding<Bool>) {
    self.credentials = credentials
    _isPresented = isPresented
  }

  // MARK: Public

  public var body: some View {
    VStack(spacing: 0) {
      ForEach(credentials) { credential in
        let index = indexOf(credential)

        VStack {
          Button(action: {
            self.credential = credential
            withAnimation {
              isPresented = true
            }
          }, label: {
            CredentialCard(credential, position: index, maximumPosition: credentials.count)
          })
          .buttonStyle(.flatLink)
        }
        .offset(y: CGFloat(index) * -CredentialCard.Defaults.cardHeight)
        .offset(y: CGFloat(index) * Defaults.cardPreviewHeight)
      }

      if let credential {
        NavigationLink(destination: CredentialDetailsCardView(credential: credential, isPresented: $isPresented), isActive: $isPresented) {
          EmptyView()
        }
      }
    }
    .padding(.bottom, CGFloat(credentials.count - 1) * -(CredentialCard.Defaults.cardHeight - Defaults.cardPreviewHeight))
  }

  // MARK: Internal

  enum Defaults {
    static let cardPreviewHeight: CGFloat = 60
  }

  // MARK: Private

  @Binding private var isPresented: Bool
  @State private var credential: Credential? = nil
  private var credentials: [Credential] = []

  private func indexOf(_ credential: Credential) -> Int {
    credentials.firstIndex { credential == $0 } ?? 0
  }

}
