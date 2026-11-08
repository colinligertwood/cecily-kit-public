// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "CecilyKit",
    platforms: [.macOS(.v27), .iOS(.v26)],
    products: [
        .library(name: "CecilyKit", targets: ["CecilyKit"])
    ],
    targets: [
        .target(
            name: "CecilyKit",
            swiftSettings: [.defaultIsolation(MainActor.self)]
        ),
        .testTarget(name: "CecilyKitTests", dependencies: ["CecilyKit"]),
    ]
)
