// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftGraph",
    products: [
        .library(
            name: "SwiftGraph",
            targets: ["SwiftGraph"]),
        .library(
            name: "GraphVizCoder",
            targets: ["GraphVizCoder"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftGraph",
            dependencies: []),
        .target(
            name: "GraphVizCoder",
            dependencies: []),
        .testTarget(
            name: "SwiftGraphTests",
            dependencies: ["SwiftGraph"]),
        .testTarget(
            name: "SwiftGraphPerformanceTests",
            dependencies: ["SwiftGraph"]),
        .testTarget(
            name: "GraphVizCoderTests",
            dependencies: ["GraphVizCoder"]),
        ]
)
