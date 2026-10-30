// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HoldSpeak",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "HoldSpeakCore", targets: ["HoldSpeakCore"]),
    ],
    // The app's dependencies, one place for their versions: scripts/sync-packages.py
    // copies them into project.yml (the app build), and Dependabot bumps them here.
    // Minor-pinned where 0.x or internals are relied on (ParakeetVocabulary uses
    // FluidAudio internals). Only GRDB is used by the targets below.
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3"),
        .package(url: "https://github.com/argmaxinc/argmax-oss-swift", .upToNextMinor(from: "1.1.1")),
        .package(url: "https://github.com/FluidInference/FluidAudio", .upToNextMinor(from: "0.17.5")),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.7.0"),
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
