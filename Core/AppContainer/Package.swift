// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    // // Nombre del paquete
    name: "AppContainer",

    // // Mínimo iOS que soporta este package (debe alinearse con CoreModels/CoreNetworking)
    platforms: [
        .iOS(.v17)
    ],

    // // Lo que este package expone hacia afuera (lo que otros importan)
    products: [
        .library(
            name: "AppContainer",
            targets: ["AppContainer"]
        )
    ],

    // // Dependencias locales (rutas relativas desde AppContainer/)
    dependencies: [
        .package(path: "../CoreNetworking"),
        .package(path: "../CorePersistence")
    ],

    // // Targets (módulos) del package
    targets: [
        .target(
            name: "AppContainer",
            dependencies: [
                // // Importa el producto CoreNetworking del package CoreNetworking
                .product(name: "CoreNetworking", package: "CoreNetworking"),
                // // Importa el producto CorePersistence del package CorePersistence
                .product(name: "CorePersistence", package: "CorePersistence")
            ]
        )
    ]
)
