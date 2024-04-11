import SwiftUI

extension LabelStyle where Self == StandardStatusLabelStyle {
  public static var standardStatus: StandardStatusLabelStyle { StandardStatusLabelStyle() }
}

extension LabelStyle where Self == ErrorStatusLabelStyle {
  public static var errorStatus: ErrorStatusLabelStyle { ErrorStatusLabelStyle() }
}

extension LabelStyle where Self == WarningStatusLabelStyle {
  public static var warningStatus: WarningStatusLabelStyle { WarningStatusLabelStyle() }
}

extension LabelStyle where Self == InfoStatusLabelStyle {
  public static var infoStatus: InfoStatusLabelStyle { InfoStatusLabelStyle() }
}

// MARK: - StandardStatusLabelStyle

public struct StandardStatusLabelStyle: LabelStyle {
  public init() {}
  public func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: .x1) {
      configuration.icon
      configuration.title
    }
    .font(.custom.footnote2)
    .foregroundColor(.primary)
  }
}

// MARK: - ErrorStatusLabelStyle

public struct ErrorStatusLabelStyle: LabelStyle {
  public init() {}
  public func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: .x1) {
      configuration.icon
      configuration.title
    }
    .font(.custom.footnote2)
    .foregroundColor(ThemingAssets.red.swiftUIColor)
  }
}

// MARK: - WarningStatusLabelStyle

public struct WarningStatusLabelStyle: LabelStyle {
  public init() {}
  public func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.icon
      configuration.title
    }
    .font(.custom.footnote2)
    .foregroundColor(ThemingAssets.orange.swiftUIColor)
  }
}

// MARK: - InfoStatusLabelStyle

public struct InfoStatusLabelStyle: LabelStyle {
  public init() {}
  public func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.icon
      configuration.title
    }
    .font(.custom.footnote2)
    .foregroundColor(ThemingAssets.petrol.swiftUIColor)
  }
}
