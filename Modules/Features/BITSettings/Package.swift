// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITSettings",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITSettings",
      targets: ["BITSettings"]),
  ],
  dependencies: [
    .package(path: "../BITAppAuth"),
    .package(path: "../BITAppVersion"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
  ],
  targets: [
    .target(
      name: "BITSettings",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITAppAuth", package: "BITAppAuth"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITAppVersion", package: "BITAppVersion"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "Factory", package: "Factory"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITSettingsTests",
      dependencies: [
        "BITSettings",
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
