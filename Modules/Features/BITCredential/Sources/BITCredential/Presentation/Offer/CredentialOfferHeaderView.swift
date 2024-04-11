import BITTheming
import Foundation
import SDWebImageSwiftUI
import SwiftUI

// MARK: - CredentialOfferHeaderView

public struct CredentialOfferHeaderView: View {

  // MARK: Lifecycle

  init(viewModel: CredentialOfferHeaderViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Public

  public var body: some View {
    HStack(alignment: .top, spacing: .x3) {
      if let imageData = viewModel.imageData {
        Image(data: imageData)?
          .applyCircleShape(size: 50, padding: .x1)
      }

      VStack(alignment: .leading, spacing: 0) {
        Text(viewModel.name)
          .tracking(-0.5)
          .font(.custom.headline)
        Text(L10n.credentialOfferInvitation)
          .tracking(-0.1)
          .lineSpacing(-2)
          .lineLimit(2)
      }

      Spacer()
    }
    .font(.custom.body)
  }

  // MARK: Private

  private var viewModel: CredentialOfferHeaderViewModel

}
