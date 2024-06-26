// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITCredential",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITCredential",
      targets: ["BITCredential"]),
    .library(
      name: "BITCredentialMocks",
      targets: ["BITCredentialMocks"]),
  ],
  dependencies: [
    .package(path: "../BITAppAuth"),
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITNetworking"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITSdJWT"),
    .package(path: "../../Platforms/BITVault"),
    .package(path: "../../Platforms/BITDataStore"),
    .package(path: "../../Platforms/BITLocalAuthentication"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../BITCredentialShared"),
    .package(path: "../BITActivity"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", exact: "2.2.6"),
    .package(url: "https://github.com/KittyMac/Sextant.git", revision: "e59c57e4fa19a02f336cd91b9f6cd8e4022e5ed0"),
    .package(url: "https://github.com/gh123man/SwiftUI-Refresher", exact: "1.1.8"),
  ],
  targets: [
    .target(
      name: "BITCredential",
      dependencies: [
        .product(name: "BITAppAuth", package: "BITAppAuth"),
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITNetworking", package: "BITNetworking"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITSdJWT", package: "BITSdJWT"),
        .product(name: "BITVault", package: "BITVault"),
        .product(name: "BITDataStore", package: "BITDataStore"),
        .product(name: "BITLocalAuthentication", package: "BITLocalAuthentication"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITCredentialShared", package: "BITCredentialShared"),
        .product(name: "BITActivity", package: "BITActivity"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "Sextant", package: "Sextant"),
        .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
        .product(name: "Refresher", package: "SwiftUI-Refresher"),
      ],
      resources: [.process("Resources")]),
    .target(
      name: "BITCredentialMocks",
      dependencies: [
        "BITCredential",
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTestingCore", package: "BITCore"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITCredentialTests",
      dependencies: [
        "BITCredential",
        .product(name: "BITCredentialSharedMocks", package: "BITCredentialShared"),
        .product(name: "BITSdJWTMocks", package: "BITSdJWT"),
        "BITCredentialMocks",
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITActivityMocks", package: "BITActivity"),
      ]),
  ])
