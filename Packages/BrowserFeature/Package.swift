// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BrowserFeature",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BrowserFeature",
            targets: ["BrowserFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            exact: "0.52.0"
        )
    ],
    targets: [
        .target(
            name: "BrowserFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Networking"
            ]
        ),
        .testTarget(
            name: "BrowserFeatureTests",
            dependencies: ["BrowserFeature"]
        ),
    ]
)
