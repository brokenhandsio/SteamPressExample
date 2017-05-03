import PackageDescription

let package = Package(
    name: "SteamPressExample",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", Version(2,0,0, prereleaseIdentifiers: ["beta"])),
        .Package(url: "https://github.com/brokenhandsio/SteamPress.git", Version(0,11,0, prereleaseIdentifiers: ["alpha"])),
        .Package(url: "https://github.com/brokenhandsio/VaporSecurityHeaders.git", Version(0,4,0, prereleaseIdentifiers: ["beta"])),
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
