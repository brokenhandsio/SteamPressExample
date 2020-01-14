// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SteamPressExample",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/brokenhandsio/leaf-error-middleware.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/brokenhandsio/VaporSecurityHeaders.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/brokenhandsio/steampress-fluent-postgres.git", .upToNextMajor(from: "1.0.0-alpha")),
        .package(url: "https://github.com/vapor-community/leaf-markdown.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "App",
            dependencies: [
                "Leaf",
                "LeafErrorMiddleware",
                "VaporSecurityHeaders",
                "SteampressFluentPostgres",
                "LeafMarkdown"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        .target(name: "Run", dependencies: ["App"])
    ]
)
