// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppContainer",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppContainer",
            targets: ["AppContainer"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreNetworking"),
    ],
    targets: [
        .target(
            name: "AppContainer",
            dependencies: [
                .product(name: "CoreNetworking", package: "CoreNetworking"),
            ]
        ),
    ]
)
