import SwiftUI

extension ButtonStyle where Self == PrimaryProminentButtonStyle {
  public static var primaryProminent: PrimaryProminentButtonStyle { PrimaryProminentButtonStyle(buttonConfiguration: .default) }
  public static var primaryProminentReversed: PrimaryProminentButtonStyle { PrimaryProminentButtonStyle(buttonConfiguration: .reversed) }
  public static var primaryProminentSecondary: PrimaryProminentButtonStyle { PrimaryProminentButtonStyle(buttonConfiguration: .secondary) }
  public static var primaryProminentDestructive: PrimaryProminentButtonStyle { PrimaryProminentButtonStyle(buttonConfiguration: .destructive) }
}

// MARK: - PrimaryProminentButtonStyle

public struct PrimaryProminentButtonStyle: ButtonStyle {

  private var buttonConfiguration: PrimaryButtonConfiguration

  public init(buttonConfiguration: PrimaryButtonConfiguration) {
    self.buttonConfiguration = buttonConfiguration
  }

  public func makeBody(configuration: Configuration) -> some View {
    PrimaryProminentButton(configuration: configuration, buttonConfiguration: buttonConfiguration)
  }
}

// MARK: - PrimaryProminentButton

public struct PrimaryProminentButton: View {

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
      .padding(.x3)
      .font(.custom.headline2)
      .background(isEnabled ? buttonConfiguration.backgroundColor : buttonConfiguration.backgroundColorDisabled)
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
