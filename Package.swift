// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "pilotWallet-Danger",
  defaultLocalization: "en",
  products: [
    .library(name: "DangerDeps", type: .dynamic, targets: ["pilotWallet-Danger"]),
  ],
  dependencies: [
    .package(url: "https://github.com/danger/swift.git", from: "3.15.0"),
  ],
  targets: [
    .target(
      name: "pilotWallet-Danger",
      dependencies: [
        .product(name: "Danger", package: "swift"),
      ],
      path: "pilotWallet",
      sources: ["Resources/DangerProxy.swift"]),
  ])
