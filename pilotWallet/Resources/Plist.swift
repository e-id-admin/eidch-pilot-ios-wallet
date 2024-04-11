// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - PlistFiles

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
enum PlistFiles {

  // MARK: Internal

  static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
  static let cfBundleDisplayName: String = _document["CFBundleDisplayName"]
  static let cfBundleExecutable: String = _document["CFBundleExecutable"]
  static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
  static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
  static let cfBundleName: String = _document["CFBundleName"]
  static let cfBundlePackageType: String = _document["CFBundlePackageType"]
  static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
  static let cfBundleURLTypes: [[String: Any]] = _document["CFBundleURLTypes"]
  static let cfBundleVersion: String = _document["CFBundleVersion"]
  static let itsAppUsesNonExemptEncryption: Bool = _document["ITSAppUsesNonExemptEncryption"]
  static let lsHasLocalizedDisplayName: Bool = _document["LSHasLocalizedDisplayName"]
  static let nsAppTransportSecurity: [String: Any] = _document["NSAppTransportSecurity"]
  static let nsCameraUsageDescription: String = _document["NSCameraUsageDescription"]
  static let nsFaceIDUsageDescription: String = _document["NSFaceIDUsageDescription"]
  static let uiApplicationSceneManifest: [String: Any] = _document["UIApplicationSceneManifest"]
  static let uiApplicationSupportsIndirectInputEvents: Bool = _document["UIApplicationSupportsIndirectInputEvents"]
  static let uiLaunchScreen: [String: Any] = _document["UILaunchScreen"]
  static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
  static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
  static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
  static let uiUserInterfaceStyle: String = _document["UIUserInterfaceStyle"]

  // MARK: Private

  private static let _document = PlistDocument(path: "Info.plist")
}

// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  guard
    let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
    let data = NSArray(contentsOf: url) as? [T] else
  {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

// MARK: - PlistDocument

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    guard
      let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
      let data = NSDictionary(contentsOf: url) as? [String: Any] else
    {
      fatalError("Unable to load PLIST at path: \(path)")
    }
    self.data = data
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

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
