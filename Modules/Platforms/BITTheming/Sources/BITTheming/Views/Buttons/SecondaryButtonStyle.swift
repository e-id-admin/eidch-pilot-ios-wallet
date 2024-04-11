import SwiftUI

extension PrimitiveButtonStyle where Self == SecondaryProminentButtonStyle {
  public static var secondaryProminant: SecondaryProminentButtonStyle { SecondaryProminentButtonStyle() }
}

extension PrimitiveButtonStyle where Self == SecondaryProminentReversedButtonStyle {
  public static var secondaryProminantReversed: SecondaryProminentReversedButtonStyle { SecondaryProminentReversedButtonStyle() }
}

// MARK: - SecondaryProminentButtonStyle

public struct SecondaryProminentButtonStyle: PrimitiveButtonStyle {

  // MARK: Public

  public func makeBody(configuration: Configuration) -> some View {
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
          .stroke(isEnabled ? ThemingAssets.accentColor.swiftUIColor : ThemingAssets.petrol2.swiftUIColor, lineWidth: 2)
          .onTapGesture {
            if isEnabled {
              configuration.trigger()
            }
          }
      )
      .onTapGesture {
        if isEnabled {
          configuration.trigger()
        }
      }
  }

  // MARK: Internal

  @Environment(\.isEnabled) var isEnabled

}

// MARK: - SecondaryProminentReversedButtonStyle

public struct SecondaryProminentReversedButtonStyle: PrimitiveButtonStyle {

  // MARK: Public

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.x3)
      .font(.custom.headline2)
      .background(isEnabled ? ThemingAssets.background.swiftUIColor : ThemingAssets.background.swiftUIColor.opacity(0.7))
      .progressViewStyle(CircularProgressViewStyle(tint: ThemingAssets.accentColor.swiftUIColor))
      .foregroundColor(ThemingAssets.accentColor.swiftUIColor)
      .clipShape(.rect(cornerRadius: .x1))
      .onTapGesture {
        if isEnabled {
          configuration.trigger()
        }
      }
  }

  // MARK: Internal

  @Environment(\.isEnabled) var isEnabled

}
