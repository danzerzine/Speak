// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HoldSpeak",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "HoldSpeakCore", targets: ["HoldSpeakCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift", from: "7.11.1"),
        .package(url: "https://github.com/argmaxinc/WhisperKit", from: "1.1.1"),
    ],
    targets: [
        .target(
            name: "ObjCCatch",
            path: "Sources/ObjCCatch"
        ),
        .target(
            name: "HoldSpeakCore",
            dependencies: [
                "ObjCCatch",
                .product(name: "GRDB", package: "GRDB.swift"),
            ],
            path: "Sources/Core"
        ),
        .testTarget(
            name: "HoldSpeakCoreTests",
            dependencies: ["HoldSpeakCore", "ObjCCatch"],
            path: "Tests"
        ),
    ]
)
