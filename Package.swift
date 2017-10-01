// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SteamPressExample",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/mysql-provider.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/leaf-provider.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/brokenhandsio/leaf-error-middleware.git", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/brokenhandsio/VaporSecurityHeaders.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/brokenhandsio/SteamPress.git", .upToNextMajor(from: "0.16.0"))
    ],
    targets: [
        .target(name: "App",
            dependencies: [
                "Vapor",
                "MySQLProvider",
                "LeafProvider",
                "LeafErrorMiddleware",
                "VaporSecurityHeaders",
                "SteamPress"],
            exclude: [
                "Config",
                "Database",
                "Localization",
                "Public",
                "Resources",]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        .target(name: "Run", dependencies: ["App"])
    ]
)
