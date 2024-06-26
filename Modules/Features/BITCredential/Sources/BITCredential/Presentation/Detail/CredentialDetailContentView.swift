import BITActivity
import BITCredentialShared
import BITTheming
import Foundation
import SwiftUI

public struct CredentialDetailContentView: View {

  // MARK: Lifecycle

  init(credential: Credential, title: String, message: String? = nil) {
    self.title = title
    self.message = message
    self.credential = credential
    credentialBody = .init(from: credential)
  }

  init(activity: Activity, title: String, message: String? = nil) {
    self.title = title
    self.message = message
    self.activity = activity
    credential = activity.credential
    credentialBody = CredentialDetailBody(activity: activity)
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading, spacing: .x4) {
      if let activity {
        CredentialTinyCard(from: activity)
      } else {
        CredentialTinyCard(credential)
      }

      VStack(alignment: .leading, spacing: .x4) {
        VStack(alignment: .leading) {
          Text(title)
            .font(.custom.headline)

          ClaimListView(credentialBody.claims)
        }
        .padding(.horizontal, .x3)

        if let message {
          HStack {
            Label(message, systemImage: "info.circle")
              .font(.custom.subheadline)
              .foregroundColor(ThemingAssets.accentColor.swiftUIColor)
              .padding()
            Spacer()
          }
          .frame(maxWidth: .infinity)
          .background(ThemingAssets.petrol3.swiftUIColor)
          .clipShape(.rect(cornerRadius: .x1))
        }
      }
      .padding(.x4)
    }
  }

  // MARK: Private

  private var title: String
  private var message: String?
  private var credential: Credential
  private var activity: Activity? = nil
  private var credentialBody: CredentialDetailBody

}
