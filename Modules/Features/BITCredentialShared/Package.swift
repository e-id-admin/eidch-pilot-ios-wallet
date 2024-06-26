// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITCredentialShared",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITCredentialShared",
      targets: ["BITCredentialShared"]),
    .library(
      name: "BITCredentialSharedMocks",
      targets: ["BITCredentialSharedMocks"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITSdJWT"),
    .package(path: "../../Platforms/BITVault"),
    .package(path: "../../Platforms/BITDataStore"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
  ],
  targets: [
    .target(
      name: "BITCredentialShared",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "BITVault", package: "BITVault"),
        .product(name: "BITSdJWT", package: "BITSdJWT"),
        .product(name: "BITDataStore", package: "BITDataStore"),
      ]),
    .target(
      name: "BITCredentialSharedMocks",
      dependencies: [
        "BITCredentialShared",
        .product(name: "BITTestingCore", package: "BITCore"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITCredentialSharedTests",
      dependencies: [
        "BITCredentialShared", "BITCredentialSharedMocks",
      ]),
  ])
