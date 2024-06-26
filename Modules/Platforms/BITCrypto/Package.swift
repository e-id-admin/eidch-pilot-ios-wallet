// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITCrypto",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITCrypto",
      targets: ["BITCrypto"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITCrypto",
      dependencies: [
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .testTarget(
      name: "BITCryptoTests",
      dependencies: [
        "BITCrypto",
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
