import BITTheming
import Foundation
import SwiftUI

public struct CredentialDetailContentView: View {

  // MARK: Lifecycle

  init(credential: Credential) {
    self.credential = credential
    credentialBody = .init(from: credential)
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading, spacing: .x4) {
      CredentialTinyCard(credential)

      VStack(alignment: .leading, spacing: .x4) {
        VStack(alignment: .leading) {
          Text(L10n.credentialOfferContentSectionTitle)
            .font(.custom.headline)

          ClaimListView(credentialBody.claims)
        }
        .padding(.horizontal, .x3)

        HStack {
          Label(L10n.credentialOfferSupportMessage, systemImage: "info.circle")
            .font(.custom.subheadline)
            .foregroundColor(ThemingAssets.accentColor.swiftUIColor)
            .padding()
          Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(ThemingAssets.petrol3.swiftUIColor)
        .clipShape(.rect(cornerRadius: .x1))
      }
      .padding(.x4)
    }
  }

  // MARK: Private

  private var credential: Credential
  private var credentialBody: CredentialDetailBody

}
