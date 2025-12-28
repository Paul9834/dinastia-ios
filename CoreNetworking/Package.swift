// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreNetworking",
    platforms: [
        // // Alinea el mínimo iOS del package con CoreModels (y el proyecto)
        .iOS(.v17)
    ],
    products: [
        .library(name: "CoreNetworking", targets: ["CoreNetworking"])
    ],
    dependencies: [
        // // Dependencia local para poder importar CoreModels desde CoreNetworking
        .package(path: "../CoreModels")
    ],
    targets: [
        .target(
            name: "CoreNetworking",
            dependencies: [
                // // Exponemos el producto CoreModels para usar LoginRequest/LoginResponse, etc.
                .product(name: "CoreModels", package: "CoreModels")
            ]
        )
    ]
)
