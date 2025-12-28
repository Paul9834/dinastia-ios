// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreModels",
    platforms: [
        // // Mínimo iOS para compilar el paquete (puedes subirlo si quieres)
        .iOS(.v17)
    ],
    products: [
        // // Librería que otros módulos pueden importar: import CoreModels
        .library(name: "CoreModels", targets: ["CoreModels"])
    ],
    targets: [
        // // Target principal del paquete
        .target(
            name: "CoreModels"
        )
    ]
)
