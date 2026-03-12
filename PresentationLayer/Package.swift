// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [
        .iOS(.v17),
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
        .package(path: "../PlatformLayer"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PresentationLayer",
            dependencies: ["DomainLayer", "PlatformLayer", "Kingfisher"]
        ),
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["PresentationLayer"]
        ),
    ]
)
