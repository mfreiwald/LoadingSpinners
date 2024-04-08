// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Deck",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "Deck",
            targets: ["Deck"]),
    ],
    dependencies: [
        .package(name: "DeckUI", path: "../../../../../github/DeckUI")
    ],
    targets: [
        .target(
            name: "Deck",
            dependencies: [
                .product(name: "DeckUI", package: "DeckUI")
            ]
        ),
        .testTarget(
            name: "DeckTests",
            dependencies: ["Deck"]),
    ]
)
