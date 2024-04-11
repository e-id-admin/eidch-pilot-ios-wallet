import BITTheming
import SwiftUI

struct ToggleMenuCell: View {

  // MARK: Lifecycle

  init(text: String, isOn: Binding<Bool>, _ onTap: (() -> Void)? = nil) {
    self.text = Text(text)
    self.onTap = onTap
    _isOn = isOn
  }

  // MARK: Internal

  @Binding var isOn: Bool

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .firstTextBaseline, spacing: .x4) {
        HStack(alignment: .firstTextBaseline) {
          text

          Spacer(minLength: .x2)

          Toggle("", isOn: $isOn)
            .tint(ThemingAssets.accentColor.swiftUIColor)
            .offset(y: -20)
            .onTapGesture {
              onTap?()
            }
            .simultaneousGesture(
              LongPressGesture()
                .onEnded { _ in onTap?() }
            )
        }
      }

      if hasDivider {
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundStyle(ThemingAssets.gray3.swiftUIColor)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onTap?()
    }
    .onLongPressGesture {
      onTap?()
    }
  }

  // MARK: Private

  @Environment(\.menuCellDivider) private var hasDivider: Bool
  private var text: Text
  private var onTap: (() -> Void)?
}

#Preview {
  ToggleMenuCell(text: "Menu cell", isOn: .constant(true))
}
