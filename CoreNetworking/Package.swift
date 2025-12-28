// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreNetworking",
    products: [
        .library(name: "CoreNetworking", targets: ["CoreNetworking"])
    ],
    dependencies: [
        // // Dependencia local al paquete CoreModels
        .package(path: "../CoreModels")
    ],
    targets: [
        .target(
            name: "CoreNetworking",
            dependencies: [
                // // Importa el producto CoreModels para poder hacer: import CoreModels
                .product(name: "CoreModels", package: "CoreModels")
            ]
        )
    ]
)
