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

      TagList(data: fields, spacing: .x1, alignment: .leading) { item in
        Label(
          title: { Text(item.displayName) },
          icon: { Image(systemName: "checkmark")
            .foregroundColor(ThemingAssets.green.swiftUIColor)
          })
          .labelStyle(.badge)
          .padding(.trailing, .x1)
      }
    }
  }

  // MARK: Private

  private var header: String?
  private var fields: [PresentationMetadata.Field] = []

}
