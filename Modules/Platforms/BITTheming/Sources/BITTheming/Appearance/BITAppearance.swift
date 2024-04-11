import Foundation
import UIKit

// MARK: - BITAppearance

public class BITAppearance {

  public static func setup() {
    BITAppearance.registerFonts()
    BITAppearance.setUIViewAppearance()
    BITAppearance.setUILabels()
    BITAppearance.setUISearchBar()
    BITAppearance.setUIBarButtonItem()
    BITAppearance.setUINavigationBarAppearance()
  }

}

extension BITAppearance {

  //MARK: - UI components

  private static func registerFonts() {
    FontFamily.registerAllCustomFonts()
  }

  private static func setUIViewAppearance() {
    let appearance = UIView.appearance()
    appearance.tintColor = ThemingAssets.accentColor.color
  }

  private static func setUILabels() {
    let headerLabels = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
    headerLabels.font = UIFont.preferredFont(forTextStyle: .callout, font: FontFamily.NotoSans.regular)
  }

  private static func setUISearchBar() {
    let searchBarAppeareance = UISearchBar.appearance()
    searchBarAppeareance.tintColor = ThemingAssets.accentColor.color
    searchBarAppeareance.searchBarStyle = .default
  }

  private static func setUIBarButtonItem() {
    let barButtonItem = UIBarButtonItem.appearance()
    let attributes = [
      NSAttributedString.Key.foregroundColor: ThemingAssets.accentColor.color,
      NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, font: FontFamily.NotoSans.regular),
    ]

    barButtonItem.setTitleTextAttributes(attributes, for: .normal)
    barButtonItem.setTitleTextAttributes(attributes, for: .highlighted)
  }

  private static func setUINavigationBarAppearance() {
    let inlineTitleTextAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, font: FontFamily.NotoSans.semiBold)]
    let largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle, font: FontFamily.NotoSans.semiBold)]

    UINavigationBar.appearance().tintColor = ThemingAssets.accentColor.color
    UINavigationBar.appearance().titleTextAttributes = inlineTitleTextAttributes
    UINavigationBar.appearance().largeTitleTextAttributes = largeTitleTextAttributes
    UINavigationBar.appearance().prefersLargeTitles = false
  }

}
