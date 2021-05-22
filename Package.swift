// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnserAPIKit",
    products: [
        .library(
            name: "UnserAPIKit",
            targets: ["UnserAPIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
      .package(url: "https://github.com/Quick/Nimble.git", from: "9.2.0"),
        .package(
            url: "https://github.com/Flight-School/AnyCodable",
            from: "0.2.3"
        ),
    ],
    targets: [
        .target(
            name: "UnserAPIKit",
            dependencies: []),
        .testTarget(
            name: "UnserAPIKitTests",
            dependencies: ["UnserAPIKit", "Quick", "Nimble", "AnyCodable"]),
    ]
)
