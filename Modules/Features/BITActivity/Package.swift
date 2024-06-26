// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITActivity",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITActivity",
      targets: ["BITActivity"]),
    .library(
      name: "BITActivityMocks",
      targets: ["BITActivityMocks"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITDataStore"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../BITCredentialShared"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITActivity",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "BITCredentialShared", package: "BITCredentialShared"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "BITDataStore", package: "BITDataStore"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITTheming", package: "BITTheming"),
      ]),
    .target(
      name: "BITActivityMocks",
      dependencies: [
        "BITActivity",
        .product(name: "BITTestingCore", package: "BITCore"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITActivityTests",
      dependencies: [
        "BITActivity",
        "BITActivityMocks",
        .product(name: "BITCredentialSharedMocks", package: "BITCredentialShared"),
      ]),
  ])
