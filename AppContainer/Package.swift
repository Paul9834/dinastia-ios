import PackageDescription

let package = Package(
    name: "AppContainer",
    products: [
        .library(name: "AppContainer", targets: ["AppContainer"])
    ],
    dependencies: [
        .package(path: "../CoreNetworking"),
        .package(path: "../CorePersistence")
    ],
    targets: [
        .target(
            name: "AppContainer",
            dependencies: [
                .product(name: "CoreNetworking", package: "CoreNetworking"),
                .product(name: "CorePersistence", package: "CorePersistence")
            ]
        )
    ]
)
