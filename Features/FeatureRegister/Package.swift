// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "FeatureRegister",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureRegister", targets: ["FeatureRegister"])
    ],
    dependencies: [
        .package(path: "../../Core/CoreModels"),
        .package(path: "../../Core/CoreFoundationKit"),
        .package(path: "../../Core/CoreNetworking"),
        .package(path: "../../Core/CorePersistence"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../AppContainer")
    ],
    targets: [
        .target(
            name: "FeatureRegister",
            dependencies: [
                .product(name: "CoreModels", package: "CoreModels"),
                .product(name: "CoreFoundationKit", package: "CoreFoundationKit"),
                .product(name: "CoreNetworking", package: "CoreNetworking"),
                .product(name: "CorePersistence", package: "CorePersistence"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "AppContainer", package: "AppContainer")
            ]
        )
    ]
)
