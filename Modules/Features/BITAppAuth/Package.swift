// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITAppAuth",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITAppAuth",
      targets: ["BITAppAuth"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITCrypto"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITVault"),
    .package(path: "../../Platforms/BITLocalAuthentication"),
    .package(path: "../../Platforms/BITNavigation"),
  ],
  targets: [
    .target(
      name: "BITAppAuth",
      dependencies: [
        .product(name: "Factory", package: "Factory"),
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITCrypto", package: "BITCrypto"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "BITVault", package: "BITVault"),
        .product(name: "BITLocalAuthentication", package: "BITLocalAuthentication"),
        .product(name: "BITNavigation", package: "BITNavigation"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITAppAuthTests",
      dependencies: [
        "BITAppAuth",
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
