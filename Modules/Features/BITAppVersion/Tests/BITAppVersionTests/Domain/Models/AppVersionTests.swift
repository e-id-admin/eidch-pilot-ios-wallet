import Foundation
import XCTest
@testable import BITAppVersion

class AppVersionTests: XCTestCase {

  func test_rawValues() {
    let version = "1.0.0"
    let appVersion = AppVersion(version)

    XCTAssertEqual(appVersion.rawValue, version)
    XCTAssertEqual(appVersion.major, 1)
    XCTAssertEqual(appVersion.minor, 0)
    XCTAssertEqual(appVersion.patch, 0)
  }

  func test_versionComparaison() {
    let appVersion = AppVersion("0.0.1")
    let newAppVersion = AppVersion("0.0.2")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_major() {
    let appVersion = AppVersion("1.0.0")
    let newAppVersion = AppVersion("1.0.0")

    XCTAssertEqual(newAppVersion, appVersion)
  }

  func test_majorBump() {
    let appVersion = AppVersion("1.0.0")
    let newAppVersion = AppVersion("2.0.0")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_majorRoolback_patchBump() {
    let appVersion = AppVersion("1.0.0")
    let newAppVersion = AppVersion("0.0.1203123")

    XCTAssertLessThan(newAppVersion, appVersion)
  }

  func test_majorBump_withMinorRollback() {
    let appVersion = AppVersion("1.10.0")
    let newAppVersion = AppVersion("2.0.0")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_minorBump() {
    let appVersion = AppVersion("1.1.0")
    let newAppVersion = AppVersion("1.2.0")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_minorBump_extremes() {
    let appVersion = AppVersion("1.2029124.43420998")
    let newAppVersion = AppVersion("1.2029126.120998")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_minorAndMajorBump() {
    let appVersion = AppVersion("1.1.0")
    let newAppVersion = AppVersion("2.2.0")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_patchBump() {
    let appVersion = AppVersion("1.1.1")
    let newAppVersion = AppVersion("1.1.2")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_patchBump_smallerVersion() {
    let appVersion = AppVersion("1.2.1")
    let newAppVersion = AppVersion("1.1.200")

    XCTAssertLessThan(newAppVersion, appVersion)
  }

  func test_weirdVersions() {
    let appVersion = AppVersion("0123.0123.000001")
    let newAppVersion = AppVersion("0123.01234.000001")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_onlyMajorVersion() {
    let appVersion = AppVersion("1")
    let newAppVersion = AppVersion("2")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_onlyMajorVersion_lessThan() {
    let appVersion = AppVersion("201")
    let newAppVersion = AppVersion("101")

    XCTAssertLessThan(newAppVersion, appVersion)
  }

  func test_onlyMajorAndMinor() {
    let appVersion = AppVersion("1.1")
    let newAppVersion = AppVersion("1.2")

    XCTAssertGreaterThan(newAppVersion, appVersion)
  }

  func test_onlyMajorAndMinor_lessThan() {
    let appVersion = AppVersion("1.1")
    let newAppVersion = AppVersion("0.30")

    XCTAssertLessThan(newAppVersion, appVersion)
  }

}
