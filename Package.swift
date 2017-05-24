import PackageDescription

let package = Package(
    name: "SteamPressExample",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/brokenhandsio/SteamPress.git", majorVersion: 0),
        .Package(url: "https://github.com/brokenhandsio/VaporSecurityHeaders.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)
