// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
public typealias Font = FontConvertible.Font

// MARK: - FontFamily

// swiftlint:disable superfluous_disable_command file_length implicit_return

// swiftlint:disable identifier_name line_length type_body_length
public enum FontFamily {
  public enum NotoSans {
    public static let black = FontConvertible(name: "NotoSans-Black", family: "Noto Sans", path: "NotoSans-Black.ttf")
    public static let blackItalic = FontConvertible(name: "NotoSans-BlackItalic", family: "Noto Sans", path: "NotoSans-BlackItalic.ttf")
    public static let bold = FontConvertible(name: "NotoSans-Bold", family: "Noto Sans", path: "NotoSans-Bold.ttf")
    public static let boldItalic = FontConvertible(name: "NotoSans-BoldItalic", family: "Noto Sans", path: "NotoSans-BoldItalic.ttf")
    public static let extraBold = FontConvertible(name: "NotoSans-ExtraBold", family: "Noto Sans", path: "NotoSans-ExtraBold.ttf")
    public static let extraBoldItalic = FontConvertible(name: "NotoSans-ExtraBoldItalic", family: "Noto Sans", path: "NotoSans-ExtraBoldItalic.ttf")
    public static let extraLight = FontConvertible(name: "NotoSans-ExtraLight", family: "Noto Sans", path: "NotoSans-ExtraLight.ttf")
    public static let extraLightItalic = FontConvertible(name: "NotoSans-ExtraLightItalic", family: "Noto Sans", path: "NotoSans-ExtraLightItalic.ttf")
    public static let italic = FontConvertible(name: "NotoSans-Italic", family: "Noto Sans", path: "NotoSans-Italic.ttf")
    public static let light = FontConvertible(name: "NotoSans-Light", family: "Noto Sans", path: "NotoSans-Light.ttf")
    public static let lightItalic = FontConvertible(name: "NotoSans-LightItalic", family: "Noto Sans", path: "NotoSans-LightItalic.ttf")
    public static let medium = FontConvertible(name: "NotoSans-Medium", family: "Noto Sans", path: "NotoSans-Medium.ttf")
    public static let mediumItalic = FontConvertible(name: "NotoSans-MediumItalic", family: "Noto Sans", path: "NotoSans-MediumItalic.ttf")
    public static let regular = FontConvertible(name: "NotoSans-Regular", family: "Noto Sans", path: "NotoSans-Regular.ttf")
    public static let semiBold = FontConvertible(name: "NotoSans-SemiBold", family: "Noto Sans", path: "NotoSans-SemiBold.ttf")
    public static let semiBoldItalic = FontConvertible(name: "NotoSans-SemiBoldItalic", family: "Noto Sans", path: "NotoSans-SemiBoldItalic.ttf")
    public static let thin = FontConvertible(name: "NotoSans-Thin", family: "Noto Sans", path: "NotoSans-Thin.ttf")
    public static let thinItalic = FontConvertible(name: "NotoSans-ThinItalic", family: "Noto Sans", path: "NotoSans-ThinItalic.ttf")
    public static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, extraLight, extraLightItalic, italic, light, lightItalic, medium, mediumItalic, regular, semiBold, semiBoldItalic, thin, thinItalic]
  }

  public static let allCustomFonts: [FontConvertible] = [NotoSans.all].flatMap { $0 }

  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}

// MARK: - FontConvertible

// swiftlint:enable identifier_name line_length type_body_length

public struct FontConvertible {

  // MARK: Public

  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  public func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  public func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  // MARK: Fileprivate

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    BundleToken.bundle.url(forResource: path, withExtension: nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

}

extension FontConvertible.Font {
  public convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension SwiftUI.Font {
  public static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
extension SwiftUI.Font {
  public static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  public static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle)
    -> SwiftUI.Font
  {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// MARK: - BundleToken

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable convenience_type
