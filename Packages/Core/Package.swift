// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iankoex/UnifiedBlurHash", branch: "main"),
        .package(url: "https://github.com/apple/swift-async-algorithms", branch: "main"),
        .package(url: "https://github.com/EmergeTools/Pow", from: Version(1, 0, 0)),
        .package(url: "https://github.com/Dean151/ButtonKit", branch: "main"),
        .package(url: "https://github.com/exyte/ActivityIndicatorView", branch: "master")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "UnifiedBlurHash", package: "UnifiedBlurHash"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "ButtonKit", package: "ButtonKit"),
                .product(name: "Pow", package: "Pow"),
                .product(name: "ActivityIndicatorView", package: "ActivityIndicatorView"),
            ],
            resources: [
                .process("Resources/combined.json"),
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
