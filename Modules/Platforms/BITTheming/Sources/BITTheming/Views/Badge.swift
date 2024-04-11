import SwiftUI

// MARK: - Badge

public struct Badge<Content>: View where Content: View {

  // MARK: Lifecycle

  public init(@ViewBuilder label: @escaping () -> Content) {
    content = label
  }

  // MARK: Public

  public var body: some View {
    style
      .makeBody(configuration: BadgeStyleConfiguration(
        label: BadgeStyleConfiguration.Label(content: content()))
      )
      .clipShape(.rect(cornerRadius: 50, style: .circular))
  }

  // MARK: Private

  @Environment(\.badgeStyle) private var style

  @ViewBuilder private var content: () -> Content

}

// MARK: - BadgeStyle

public protocol BadgeStyle {
  associatedtype Body: View
  typealias Configuration = BadgeStyleConfiguration

  func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - BadgeStyleConfiguration

public struct BadgeStyleConfiguration {

  /// A type-erased label of a Card.
  public struct Label: View {
    public init(content: some View) {
      body = AnyView(content)
    }

    public var body: AnyView
  }

  public let label: BadgeStyleConfiguration.Label
}

// MARK: - AnyBadgeStyle

public struct AnyBadgeStyle: BadgeStyle {
  private var _makeBody: (Configuration) -> AnyView

  public init(style: some BadgeStyle) {
    _makeBody = { configuration in
      AnyView(style.makeBody(configuration: configuration))
    }
  }

  public func makeBody(configuration: Configuration) -> some View {
    _makeBody(configuration)
      .labelStyle(.badge)
      .font(.custom.subheadline)
      .lineLimit(1)
  }
}

// MARK: - BadgeStyleKey

public struct BadgeStyleKey: EnvironmentKey {
  public static var defaultValue = AnyBadgeStyle(style: DefaultBadgeStyle())
}

extension EnvironmentValues {
  public var badgeStyle: AnyBadgeStyle {
    get { self[BadgeStyleKey.self] }
    set { self[BadgeStyleKey.self] = newValue }
  }
}

extension View {
  public func badgeStyle(_ style: some BadgeStyle) -> some View {
    environment(\.badgeStyle, AnyBadgeStyle(style: style))
  }
}

// MARK: - DefaultBadgeStyle

public struct DefaultBadgeStyle: BadgeStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, .x3)
      .padding(.vertical, .x1)
      .background(Color.white.opacity(0.16))
  }
}

extension BadgeStyle where Self == DefaultBadgeStyle {
  public static var standard: DefaultBadgeStyle { DefaultBadgeStyle() }
}

// MARK: - ErrorBadgeStyle

public struct ErrorBadgeStyle: BadgeStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, .x3)
      .padding(.vertical, .x1)
      .background(ThemingAssets.red3.swiftUIColor)
      .foregroundColor(ThemingAssets.red.swiftUIColor)
  }
}

extension BadgeStyle where Self == ErrorBadgeStyle {
  public static var error: ErrorBadgeStyle { ErrorBadgeStyle() }
}

// MARK: - WarningBadgeStyle

public struct WarningBadgeStyle: BadgeStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, .x3)
      .padding(.vertical, .x1)
      .background(ThemingAssets.orange2.swiftUIColor)
      .foregroundColor(ThemingAssets.orange.swiftUIColor)
  }
}

extension BadgeStyle where Self == WarningBadgeStyle {
  public static var warning: WarningBadgeStyle { WarningBadgeStyle() }
}

// MARK: - OutlineBadgeStyle

public struct OutlineBadgeStyle: BadgeStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, .x3)
      .padding(.vertical, .x1)
      .overlay {
        RoundedRectangle(cornerRadius: 50)
          .stroke(.white, lineWidth: 1)
      }
  }
}

extension BadgeStyle where Self == OutlineBadgeStyle {
  public static var outline: OutlineBadgeStyle { OutlineBadgeStyle() }
}

// MARK: - InfoBadgeStyle

public struct InfoBadgeStyle: BadgeStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, .x3)
      .padding(.vertical, .x1)
      .background(ThemingAssets.petrol3.swiftUIColor)
      .foregroundColor(ThemingAssets.petrol.swiftUIColor)
  }
}

extension BadgeStyle where Self == InfoBadgeStyle {
  public static var info: InfoBadgeStyle { InfoBadgeStyle() }
}

// MARK: - BadgeLabelStyle

public struct BadgeLabelStyle: LabelStyle {
  private var spacing: Double = 0.0

  public init(spacing: Double) {
    self.spacing = spacing
  }

  public func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: spacing) {
      configuration.icon
      configuration.title
    }
  }
}

extension LabelStyle where Self == BadgeLabelStyle {
  public static var badge: BadgeLabelStyle { BadgeLabelStyle(spacing: 2) }
}
