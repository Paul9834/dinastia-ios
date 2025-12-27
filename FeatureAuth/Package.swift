// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureAuth",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FeatureAuth",
            targets: ["FeatureAuth"]
        )
    ],
    dependencies: [
        .package(path: "../CoreModels"),
        .package(path: "../CoreFoundationKit"),
        .package(path: "../CoreNetworking"),
        .package(path: "../CorePersistence"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "FeatureAuth",
            dependencies: [
                .product(name: "CoreModels", package: "CoreModels"),
                .product(name: "CoreFoundationKit", package: "CoreFoundationKit"),
                .product(name: "CoreNetworking", package: "CoreNetworking"),
                .product(name: "CorePersistence", package: "CorePersistence"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        )
    ]
)
