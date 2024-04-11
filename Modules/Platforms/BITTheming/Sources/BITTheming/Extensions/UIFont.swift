import Foundation
import SwiftUI
import UIKit

extension UIFont {

  public class func preferredFont(forTextStyle style: UIFont.TextStyle, font: FontConvertible, size: CGFloat? = nil) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let descriptor = preferredFont(forTextStyle: style).fontDescriptor
    let defaultSize = descriptor.pointSize
    let fontToScale: UIFont = font.font(size: size ?? defaultSize)
    return metrics.scaledFont(for: fontToScale)
  }

}

extension SwiftUI.Font {
  public struct NotoSans {
    public static var title: SwiftUI.Font = FontFamily.NotoSans.medium.swiftUIFont(size: 24, relativeTo: .title)
    public static var title2: SwiftUI.Font = FontFamily.NotoSans.medium.swiftUIFont(size: 18, relativeTo: .title2)
    public static var headline: SwiftUI.Font = FontFamily.NotoSans.semiBold.swiftUIFont(size: 16, relativeTo: .headline)
    public static var headline2: SwiftUI.Font = FontFamily.NotoSans.medium.swiftUIFont(size: 16, relativeTo: .headline)
    public static var body: SwiftUI.Font = FontFamily.NotoSans.regular.swiftUIFont(size: 16, relativeTo: .body)
    public static var textLink: SwiftUI.Font = FontFamily.NotoSans.semiBold.swiftUIFont(size: 16, relativeTo: .body)
    public static var textLink2: SwiftUI.Font = FontFamily.NotoSans.bold.swiftUIFont(size: 12, relativeTo: .body)
    public static var subheadline: SwiftUI.Font = FontFamily.NotoSans.regular.swiftUIFont(size: 14, relativeTo: .subheadline)
    public static var footnote: SwiftUI.Font = FontFamily.NotoSans.medium.swiftUIFont(size: 12, relativeTo: .footnote)
    public static var footnote2: SwiftUI.Font = FontFamily.NotoSans.regular.swiftUIFont(size: 12, relativeTo: .footnote)
    public static var light: SwiftUI.Font = FontFamily.NotoSans.extraLight.swiftUIFont(size: 12)
  }

  public static let custom = NotoSans.self

}
