import BITTheming
import Combine
import Factory
import SwiftUI

// MARK: - PinCodeState

public enum PinCodeState {
  case normal
  case error
}

// MARK: - PinCodeView

public struct PinCodeView: View {

  // MARK: Lifecycle

  public init(pinCode: Binding<PinCode>, state: PinCodeState, text: String? = nil, isKeyPadDisabled: Bool = false) {
    _pinCode = pinCode
    self.isKeyPadDisabled = isKeyPadDisabled
    self.state = state
    self.text = text
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading, spacing: .x3) {
      PinCodeDotsView(pinCode: pinCode, state: state, pinCodeSize: pinCodeSize)
        .frame(minHeight: 50, maxHeight: 200)
        .background(state == .error ? Defaults.errorBackgroundGradient : Defaults.defaultBackgroundGradient)
        .clipShape(.rect(cornerRadius: .x1))

      if let text {
        Text(text)
      }

      Spacer()

      KeyPad(string: $pinCode)
        .font(.custom.title)
        .foregroundColor(.primary)
        .frame(height: 300)
        .disabled(isKeyPadDisabled)
        .keyPadRightKey(.delete) {
          pinCode = ""
        }
    }
  }

  // MARK: Internal

  @Binding var pinCode: PinCode

  // MARK: Private

  private enum Defaults {
    static let defaultBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.gray4.swiftUIColor, ThemingAssets.gray3.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
    static let errorBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.red2.swiftUIColor, ThemingAssets.red.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
  }

  private var isKeyPadDisabled: Bool = false
  private var state: PinCodeState
  private let pinCodeSize: Int = Container.shared.pinCodeSize()
  private let text: String?

}

#Preview {
  PinCodeView(pinCode: .constant("1234"), state: .normal, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ac mauris arcu. Maecenas tincidunt molestie nunc quis aliquet. Vestibulum placerat pretium quam.")
}
