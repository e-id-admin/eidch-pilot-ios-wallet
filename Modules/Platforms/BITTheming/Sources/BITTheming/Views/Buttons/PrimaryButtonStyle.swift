import SwiftUI

extension ButtonStyle where Self == PrimaryButtonStyle {
  public static var primary: PrimaryButtonStyle { PrimaryButtonStyle(buttonConfiguration: .default) }
  public static var primaryReversed: PrimaryButtonStyle { PrimaryButtonStyle(buttonConfiguration: .reversed) }
  public static var primarySecondary: PrimaryButtonStyle { PrimaryButtonStyle(buttonConfiguration: .secondary) }
  public static var primaryDestructive: PrimaryButtonStyle { PrimaryButtonStyle(buttonConfiguration: .destructive) }
}

// MARK: - PrimaryButton

public struct PrimaryButton: View {

  // MARK: Lifecycle

  public init(
    configuration: ButtonStyle.Configuration,
    buttonConfiguration: PrimaryButtonConfiguration)
  {
    self.configuration = configuration
    self.buttonConfiguration = buttonConfiguration
  }

  // MARK: Public

  public var body: some View {
    configuration.label
      .padding(.horizontal, .x4)
      .padding(.vertical, .x2)
      .font(.custom.headline2)
      .background(isEnabled ? buttonConfiguration.backgroundColor : buttonConfiguration.backgroundColorDisabled)
      .background(configuration.isPressed ? .black.opacity(1) : .clear)
      .foregroundColor(buttonConfiguration.foregroundColor)
      .progressViewStyle(CircularProgressViewStyle(tint: buttonConfiguration.progressViewTint))
      .clipShape(.rect(cornerRadius: .x1))
      .overlay(content: { Color.clear.background(configuration.isPressed ? Color.black.opacity(0.15) : Color.clear) })
      .scaleEffect(configuration.isPressed ? CGSize(width: 0.98, height: 0.98) : CGSize(width: 1.0, height: 1.0))
      .animation(.interactiveSpring, value: configuration.isPressed)
  }

  // MARK: Internal

  let configuration: ButtonStyle.Configuration
  let buttonConfiguration: PrimaryButtonConfiguration

  // MARK: Private

  @Environment(\.isEnabled) private var isEnabled: Bool

}

// MARK: - PrimaryButtonStyle

public struct PrimaryButtonStyle: ButtonStyle {

  private var buttonConfiguration: PrimaryButtonConfiguration

  public init(buttonConfiguration: PrimaryButtonConfiguration) {
    self.buttonConfiguration = buttonConfiguration
  }

  public func makeBody(configuration: Configuration) -> some View {
    PrimaryButton(configuration: configuration, buttonConfiguration: buttonConfiguration)
  }
}
