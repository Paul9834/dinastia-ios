// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreNetworking",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "CoreNetworking", targets: ["CoreNetworking"])
    ],
    targets: [
        .target(name: "CoreNetworking")
    ]
)
