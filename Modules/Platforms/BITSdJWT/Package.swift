// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITSdJWT",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITSdJWT",
      targets: ["BITSdJWT"]),
    .library(
      name: "BITSdJWTMocks",
      targets: ["BITSdJWTMocks"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITCrypto"),
    .package(url: "https://github.com/airsidemobile/JOSESwift.git", exact: "2.4.0"),
    .package(url: "https://github.com/1024jp/GzipSwift", exact: "6.0.1"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITSdJWT",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITCrypto", package: "BITCrypto"),
        .product(name: "JOSESwift", package: "JOSESwift"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "Gzip", package: "GzipSwift"),
      ]),
    .target(
      name: "BITSdJWTMocks",
      dependencies: [
        "BITSdJWT",
        .product(name: "BITTestingCore", package: "BITCore"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITSdJWTTests",
      dependencies: [
        "BITSdJWT",
        "BITSdJWTMocks",
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
