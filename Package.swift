// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SteamPressExample",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(name: "Leaf", url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(name: "LeafErrorMiddleware", url: "https://github.com/brokenhandsio/leaf-error-middleware.git", from: "1.2.0"),
        .package(url: "https://github.com/brokenhandsio/VaporSecurityHeaders.git", from: "2.0.0"),
        .package(name: "SteampressFluentPostgres", url: "https://github.com/brokenhandsio/steampress-fluent-postgres.git", from: "1.0.0"),
        .package(name: "LeafMarkdown", url: "https://github.com/vapor-community/leaf-markdown.git", from: "2.0.0")
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
