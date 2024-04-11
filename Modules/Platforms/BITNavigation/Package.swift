// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITNavigation",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITNavigation",
      targets: ["BITNavigation"]),
  ],
  dependencies: [
    .package(path: "../BITCore"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITNavigation",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .testTarget(
      name: "BITNavigationTests",
      dependencies: ["BITNavigation"]),
  ])
