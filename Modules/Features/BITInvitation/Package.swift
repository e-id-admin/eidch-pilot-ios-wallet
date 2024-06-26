// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITInvitation",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITInvitation",
      targets: ["BITInvitation"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITNavigation"),
    .package(path: "../../Platforms/BITDeeplink"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITQRScanner"),
    .package(path: "../../Platforms/BITSdJWT"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../../Features/BITCredential"),
    .package(path: "../../Features/BITPresentation"),
    .package(path: "../../Features/BITActivity"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/exyte/PopupView", exact: "2.8.5"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITInvitation",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITNavigation", package: "BITNavigation"),
        .product(name: "BITDeeplink", package: "BITDeeplink"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITQRScanner", package: "BITQRScanner"),
        .product(name: "BITCredential", package: "BITCredential"),
        .product(name: "BITPresentation", package: "BITPresentation"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITActivity", package: "BITActivity"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "PopupView", package: "PopupView"),
        .product(name: "Spyable", package: "swift-spyable"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITInvitationTests",
      dependencies: [
        "BITInvitation",
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITCredentialMocks", package: "BITCredential"),
        .product(name: "BITSdJWTMocks", package: "BITSdJWT"),
        .product(name: "BITPresentationMocks", package: "BITPresentation"),
      ]),
  ])
