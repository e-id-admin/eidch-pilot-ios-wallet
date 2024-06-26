import BITTheming
import SwiftUI

struct PresentationResultFieldListView: View {

  // MARK: Lifecycle

  init(fields: [PresentationMetadata.Field], header: String? = nil) {
    self.fields = fields
    self.header = header
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading, spacing: .x4) {
      if let header {
        Text(header)
          .font(.custom.subheadline)
      }

      VStack(alignment: .leading, spacing: .x2) {
        ForEach(fields) { item in
          HStack(alignment: .firstTextBaseline, spacing: .x2) {
            Image(systemName: "checkmark")
              .foregroundStyle(ThemingAssets.green.swiftUIColor)
              .font(.headline)
            Text(item.displayName)
            Spacer()
          }
        }
      }
    }
  }

  // MARK: Private

  private var header: String?
  private var fields: [PresentationMetadata.Field] = []

}
