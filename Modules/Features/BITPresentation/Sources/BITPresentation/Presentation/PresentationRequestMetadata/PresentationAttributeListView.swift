import BITTheming
import Foundation
import SwiftUI

public struct PresentationAttributeListView: View {

  // MARK: Lifecycle

  init(_ attributes: [PresentationMetadata.Field]) {
    self.attributes = attributes
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading) {
      ForEach(Array(zip(attributes.indices, attributes)), id: \.0) { index, attribute in
        VStack(alignment: .leading, spacing: 0) {
          if let imageData = attribute.imageData {
            KeyValueCustomCell(key: attribute.displayName) {
              Image(data: imageData)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 250, maxHeight: 400)
            }
            .padding(.vertical, .x2)
          } else {
            KeyValueCell(key: attribute.displayName, value: attribute.value)
              .padding(.vertical, .x2)
          }

          if index != attributes.count - 1 {
            Rectangle()
              .frame(height: 1)
              .foregroundColor(ThemingAssets.gray3.swiftUIColor)
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
  }

  // MARK: Private

  private var attributes: [PresentationMetadata.Field]

}
