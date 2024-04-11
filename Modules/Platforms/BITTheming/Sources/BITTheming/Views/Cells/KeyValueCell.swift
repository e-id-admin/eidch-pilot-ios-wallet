import Foundation
import SwiftUI

// MARK: - KeyValueCell

public struct KeyValueCell: View {

  // MARK: Lifecycle

  public init(key: String, value: String, lineLimit: Int? = nil) {
    self.key = key
    self.value = value
    self.lineLimit = lineLimit
  }

  // MARK: Public

  public var body: some View {
    KeyValueCustomCell(key: key) {
      Text(value)
        .font(.custom.body)
        .lineLimit(lineLimit)
    }
  }

  // MARK: Internal

  var key: String
  var value: String
  var lineLimit: Int? = 4
}

// MARK: - KeyValueCustomCell

public struct KeyValueCustomCell<Content: View>: View {

  // MARK: Lifecycle

  public init(key: String, @ViewBuilder _ content: () -> Content) {
    self.key = key
    self.content = content()
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading, spacing: .x2) {
      Text(key)
        .lineLimit(1)
        .font(.custom.footnote)
        .foregroundColor(Color.secondary)
        .frame(height: 5)

      content
    }
  }

  // MARK: Private

  private var key: String
  private let content: Content
}

#Preview {
  VStack(alignment: .leading) {
    KeyValueCell(key: "Test", value: "Value")
    KeyValueCustomCell(key: "Test", {
      Label(
        title: { Text("Label") },
        icon: { Image(systemName: "42.circle") })
    })
  }
}
