// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITPresentation",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITPresentation",
      targets: ["BITPresentation"]),
    .library(
      name: "BITPresentationMocks",
      targets: ["BITPresentationMocks"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Features/BITCredential"),
    .package(path: "../../Platforms/BITNetworking"),
    .package(path: "../../Platforms/BITSdJWT"),
    .package(path: "../../Platforms/BITVault"),
    .package(path: "../../Platforms/BITLocalAuthentication"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "https://github.com/KittyMac/Sextant.git", revision: "e59c57e4fa19a02f336cd91b9f6cd8e4022e5ed0"),
  ],
  targets: [
    .target(
      name: "BITPresentation",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITCredential", package: "BITCredential"),
        .product(name: "BITNetworking", package: "BITNetworking"),
        .product(name: "BITSdJWT", package: "BITSdJWT"),
        .product(name: "BITVault", package: "BITVault"),
        .product(name: "BITLocalAuthentication", package: "BITLocalAuthentication"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "Sextant", package: "Sextant"),
      ],
      resources: [.process("Resources")]),
    .target(
      name: "BITPresentationMocks",
      dependencies: [
        "BITPresentation",
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITCredentialMocks", package: "BITCredential"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITPresentationTests",
      dependencies: [
        "BITPresentation",
        "BITPresentationMocks",
        .product(name: "BITSdJWTMocks", package: "BITSdJWT"),
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
