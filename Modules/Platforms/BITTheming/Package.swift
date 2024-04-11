// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "BITTheming",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITTheming",
      targets: ["BITTheming"]),
  ],
  dependencies: [
    .package(url: "https://github.com/siteline/swiftui-introspect", exact: "1.1.1"),
  ],
  targets: [
    .target(
      name: "BITTheming",
      dependencies: [
        .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
      ],
      resources: [
        .process("Resources"),
      ]),
    .testTarget(
      name: "BITThemingTests",
      dependencies: ["BITTheming"]),
  ])
