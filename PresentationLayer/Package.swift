// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .visionOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"]
        ),
    ],
    dependencies: [
        .package(path: "../DomainLayer"),
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "PresentationLayer",
            dependencies: ["DomainLayer", "DesignSystem", "Kingfisher"]
        ),
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["PresentationLayer"]
        ),
    ]
)
