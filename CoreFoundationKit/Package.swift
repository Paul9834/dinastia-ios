// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    // // Nombre del paquete
    name: "CoreFoundationKit",

    // // Mínimo iOS del package (alineado con el resto)
    platforms: [
        .iOS(.v17)
    ],

    // // Lo que este package expone hacia afuera
    products: [
        .library(
            name: "CoreFoundationKit",
            targets: ["CoreFoundationKit"]
        )
    ],

    // // Targets (módulos) del package
    targets: [
        .target(
            name: "CoreFoundationKit"
        )
    ]
)
