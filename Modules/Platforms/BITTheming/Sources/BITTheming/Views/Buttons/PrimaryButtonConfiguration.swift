import SwiftUI

// MARK: - PrimaryButtonConfiguration

public struct PrimaryButtonConfiguration {
  public init(
    foregroundColor: Color = .white,
    backgroundColor: Color = ThemingAssets.accentColor.swiftUIColor,
    backgroundColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor,
    progressViewTint: Color = .white)
  {
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.backgroundColorDisabled = backgroundColorDisabled
    self.progressViewTint = progressViewTint
  }

  var foregroundColor: Color = .white
  var backgroundColor: Color = ThemingAssets.accentColor.swiftUIColor
  var backgroundColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor
  var progressViewTint: Color = .white
}

extension PrimaryButtonConfiguration {
  public static var `default` = PrimaryButtonConfiguration()

  public static var reversed = PrimaryButtonConfiguration(
    foregroundColor: ThemingAssets.accentColor.swiftUIColor,
    backgroundColor: ThemingAssets.background.swiftUIColor,
    backgroundColorDisabled: ThemingAssets.background.swiftUIColor.opacity(0.7),
    progressViewTint: ThemingAssets.accentColor.swiftUIColor)

  public static var secondary = PrimaryButtonConfiguration(
    foregroundColor: .white,
    backgroundColor: ThemingAssets.green.swiftUIColor,
    backgroundColorDisabled: ThemingAssets.green2.swiftUIColor.opacity(0.7),
    progressViewTint: .white)

  public static var destructive = PrimaryButtonConfiguration(
    foregroundColor: .white,
    backgroundColor: ThemingAssets.red.swiftUIColor,
    backgroundColorDisabled: ThemingAssets.red2.swiftUIColor.opacity(0.7),
    progressViewTint: .white)
}
