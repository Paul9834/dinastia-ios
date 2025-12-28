// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreModels",
    platforms: [
        // // CoreModels exige iOS 17
        .iOS(.v17)
    ],
    products: [
        // // Librería que otros módulos importan: import CoreModels
        .library(name: "CoreModels", targets: ["CoreModels"])
    ],
    targets: [
        // // Target principal del package
        .target(name: "CoreModels")
    ]
)
