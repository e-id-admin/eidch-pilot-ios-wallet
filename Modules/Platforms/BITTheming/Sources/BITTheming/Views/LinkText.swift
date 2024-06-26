import SwiftUI

public struct LinkText: View {

  private let text: String

  public init(_ text: String) {
    self.text = text
  }

  public var body: some View {
    Text("\(text) \(Image(systemName: "arrow.up.right"))")
      .underline()
      .multilineTextAlignment(.leading)
      .font(.custom.textLink)
  }
}

#Preview {
  LinkText("Test")
}
