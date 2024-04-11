import BITTheming
import SwiftUI

struct PresentationInvalidErrorView: View {

  // MARK: Lifecycle

  init(attributes: [PresentationMetadata.Field]) {
    self.attributes = attributes
  }

  // MARK: Internal

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x6) {
        Assets.wallet.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: 300)

        Text(L10n.presentationValidationErrorTitle)
          .font(.custom.title)
        Text(L10n.presentationValidationErrorMessage)

        PresentationResultFieldListView(fields: attributes, header: L10n.presentationResultListTitle)
          .padding()
          .background(ThemingAssets.background.swiftUIColor)
          .foregroundColor(Color.primary)
          .clipShape(.rect(cornerRadius: 4))
          .border(width: attributes.isEmpty ? 0.0 : 1.0, color: ThemingAssets.gray3.swiftUIColor)
      }
    }
    .font(.custom.body)
    .padding(.x4)
  }

  // MARK: Private

  private var attributes: [PresentationMetadata.Field]

}
