// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CecilyKit",
    platforms: [.macOS(.v26), .iOS(.v26)],
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
