import BITAppAuth
import BITTheming
import Factory
import SwiftUI

struct OnboardingPinCodeView: View {

  // MARK: Lifecycle

  init(
    pinCode: Binding<PinCode>,
    state: PinCodeState,
    text: String? = nil,
    subtitle: String? = nil,
    isKeyPadDisabled: Bool = false,
    pageCount: Int,
    index: Binding<Int>)
  {
    _pinCode = pinCode
    self.isKeyPadDisabled = isKeyPadDisabled
    self.state = state
    self.text = text
    self.subtitle = subtitle
    self.pageCount = pageCount
    _index = index
  }

  // MARK: Internal

  @Binding var index: Int
  @Binding var pinCode: PinCode

  var body: some View {
    VStack(alignment: .center, spacing: .x6) {
      PinCodeDotsView(pinCode: pinCode, state: state, pinCodeSize: pinCodeSize)
        .frame(minHeight: 50, maxHeight: 200)
        .background(state == .error ? Defaults.errorBackgroundGradient : Defaults.defaultBackgroundGradient)
        .clipShape(.rect(cornerRadius: .x1))

      PagerDots(pageCount: pageCount, currentIndex: $index)

      if let text {
        Text(text)
          .font(.custom.title)
          .multilineTextAlignment(.center)
      }

      if let subtitle {
        Text(subtitle)
          .multilineTextAlignment(.center)
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

  // MARK: Private

  private enum Defaults {
    static let defaultBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.gray4.swiftUIColor, ThemingAssets.gray3.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
    static let errorBackgroundGradient = LinearGradient(gradient: Gradient(colors: [ThemingAssets.red2.swiftUIColor, ThemingAssets.red.swiftUIColor]), startPoint: .leading, endPoint: .trailing)
  }

  private var isKeyPadDisabled: Bool = false
  private var state: PinCodeState
  private let pinCodeSize: Int = Container.shared.pinCodeSize()
  private let text: String?
  private let subtitle: String?
  private var pageCount: Int

}
