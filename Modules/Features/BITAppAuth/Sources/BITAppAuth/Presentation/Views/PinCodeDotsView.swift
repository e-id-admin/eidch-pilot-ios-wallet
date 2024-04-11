import BITTheming
import Factory
import SwiftUI

public struct PinCodeDotsView: View {

  // MARK: Lifecycle

  public init(pinCode: PinCode, state: PinCodeState = .normal, pinCodeSize: Int = Container.shared.pinCodeSize()) {
    self.pinCode = pinCode
    self.state = state
    self.pinCodeSize = pinCodeSize
  }

  // MARK: Public

  public var body: some View {
    VStack {
      HStack(spacing: .x5) {
        Spacer()
        ForEach(0..<pinCodeSize, id: \.self) { index in
          Circle()
            .if(index >= pinCode.count) { $0.strokeBorder(strokeBorderColor(), lineWidth: 2) }
            .frame(width: 14)
            .foregroundColor(foregroundColor(index: index))
        }
        Spacer()
      }
      .modifier(ShakeEffect(animatableData: CGFloat(state == .error ? 1 : 0)))
    }
  }

  // MARK: Private

  private var pinCode: PinCode
  private var state: PinCodeState
  private let pinCodeSize: Int

  private func strokeBorderColor() -> Color {
    state == .error ? .white : ThemingAssets.gray.swiftUIColor
  }

  private func foregroundColor(index: Int) -> Color {
    if state == .error { return .white }
    return index < pinCode.count ? ThemingAssets.gray.swiftUIColor : .gray
  }

}

#Preview {
  Group {
    PinCodeDotsView(pinCode: "1234", pinCodeSize: 6)
    PinCodeDotsView(pinCode: "", state: .error, pinCodeSize: 6)
  }
}
