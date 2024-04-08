// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageTool",
    platforms: [.macOS(.v14), .iOS(.v17)],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../../../../../github/SwiftOpenAI"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/iankoex/UnifiedBlurHash", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "ImageTool",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "SwiftOpenAI", package: "SwiftOpenAI"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "UnifiedBlurHash", package: "UnifiedBlurHash"),
            ]
        ),
    ]
)
