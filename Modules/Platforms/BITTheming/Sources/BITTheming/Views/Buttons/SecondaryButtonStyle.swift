import SwiftUI

extension ButtonStyle where Self == SecondaryButtonStyle {
  public static var secondary: SecondaryButtonStyle { SecondaryButtonStyle(buttonConfiguration: .default) }
  public static var secondarySecondary: SecondaryButtonStyle { SecondaryButtonStyle(buttonConfiguration: .secondary) }
  public static var secondaryDestructive: SecondaryButtonStyle { SecondaryButtonStyle(buttonConfiguration: .destructive) }
}

// MARK: - SecondaryButton

public struct SecondaryButton: View {

  // MARK: Lifecycle

  public init(
    configuration: ButtonStyle.Configuration,
    buttonConfiguration: SecondaryButtonConfiguration)
  {
    self.configuration = configuration
    self.buttonConfiguration = buttonConfiguration
  }

  // MARK: Public

  public var body: some View {
    configuration.label
      .padding(.x3)
      .font(.custom.headline2)
      .foregroundColor(isEnabled ? ThemingAssets.accentColor.swiftUIColor : ThemingAssets.petrol2.swiftUIColor)
      .progressViewStyle(CircularProgressViewStyle(tint: ThemingAssets.accentColor.swiftUIColor))
      .clipShape(.rect(cornerRadius: .x1))
      .background(
        RoundedRectangle(
          cornerRadius: .x1,
          style: .continuous)
          .stroke(isEnabled ? buttonConfiguration.strokeColor : buttonConfiguration.strokeColorDisabled, lineWidth: 2)
      )
      .scaleEffect(configuration.isPressed ? CGSize(width: 0.98, height: 0.98) : CGSize(width: 1.0, height: 1.0))
      .animation(.interactiveSpring, value: configuration.isPressed)
  }

  // MARK: Internal

  let configuration: ButtonStyle.Configuration
  let buttonConfiguration: SecondaryButtonConfiguration

  // MARK: Private

  @Environment(\.isEnabled) private var isEnabled: Bool

}

// MARK: - SecondaryButtonStyle

public struct SecondaryButtonStyle: ButtonStyle {

  private var buttonConfiguration: SecondaryButtonConfiguration

  public init(buttonConfiguration: SecondaryButtonConfiguration) {
    self.buttonConfiguration = buttonConfiguration
  }

  public func makeBody(configuration: Configuration) -> some View {
    SecondaryButton(configuration: configuration, buttonConfiguration: buttonConfiguration)
  }
}
