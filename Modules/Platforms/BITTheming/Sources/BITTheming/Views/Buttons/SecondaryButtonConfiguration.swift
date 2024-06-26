import SwiftUI

// MARK: - SecondaryButtonConfiguration

public struct SecondaryButtonConfiguration {

  var foregroundColor: Color = ThemingAssets.accentColor.swiftUIColor
  var foregroundColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor
  var strokeColor: Color = ThemingAssets.accentColor.swiftUIColor
  var strokeColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor
  var progressViewTint: Color = ThemingAssets.accentColor.swiftUIColor

  init(
    foregroundColor: Color = ThemingAssets.accentColor.swiftUIColor,
    foregroundColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor,
    strokeColor: Color = ThemingAssets.accentColor.swiftUIColor,
    strokeColorDisabled: Color = ThemingAssets.petrol2.swiftUIColor,
    progressViewTint: Color = ThemingAssets.accentColor.swiftUIColor)
  {
    self.foregroundColor = foregroundColor
    self.foregroundColorDisabled = foregroundColorDisabled
    self.strokeColor = strokeColor
    self.strokeColorDisabled = strokeColorDisabled
    self.progressViewTint = progressViewTint
  }
}

extension SecondaryButtonConfiguration {
  public static var `default` = SecondaryButtonConfiguration()

  public static var secondary = SecondaryButtonConfiguration(
    foregroundColor: ThemingAssets.green.swiftUIColor,
    strokeColor: ThemingAssets.green.swiftUIColor,
    strokeColorDisabled: ThemingAssets.green2.swiftUIColor.opacity(0.7),
    progressViewTint: .white)

  public static var destructive = SecondaryButtonConfiguration(
    foregroundColor: ThemingAssets.red.swiftUIColor,
    strokeColor: ThemingAssets.red.swiftUIColor,
    strokeColorDisabled: ThemingAssets.red2.swiftUIColor.opacity(0.7),
    progressViewTint: .red)
}
