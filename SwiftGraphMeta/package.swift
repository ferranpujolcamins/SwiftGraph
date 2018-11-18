// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftGraphMeta",
    products: [
        .executable(
            name: "SwiftGraphMeta",
            targets: ["SwiftGraphMeta"]),
        ],
    dependencies: [
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.0")
    ],
    targets: [
        .target(
            name: "SwiftGraphMeta",
            dependencies: ["Stencil", "SwiftFormat"],
            path: "Sources/"),
        ]
)
