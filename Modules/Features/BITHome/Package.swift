// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITHome",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITHome",
      targets: ["BITHome"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITNavigation"),
    .package(path: "../../Features/BITCredential"),
    .package(path: "../../Features/BITInvitation"),
    .package(path: "../../Features/BITSettings"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITDataStore"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITHome",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITNavigation", package: "BITNavigation"),
        .product(name: "BITCredential", package: "BITCredential"),
        .product(name: "BITInvitation", package: "BITInvitation"),
        .product(name: "BITSettings", package: "BITSettings"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITDataStore", package: "BITDataStore"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .testTarget(
      name: "BITHomeTests",
      dependencies: [
        "BITHome",
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITCredentialMocks", package: "BITCredential"),
      ]),
  ])
