// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EstimotePositioningSDK",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "EstimotePositioningSDK",
            targets: ["EstimotePositioningWrapper"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Estimote/estimote-sdk-ios.git",
            .upToNextMinor(from: "2.0.0"))
    ],
    targets: [
        .binaryTarget(
            name: "EstimotePositioningSDK",
            url: "https://github.com/Estimote/estimote-positioning-sdk-ios/releases/download/v1.0.0-beta2/EstimotePositioningSDK.xcframework.zip",
            checksum: "fc497b73a345f0cba385e1b6226bb521f52c9f39fc408881a17ab7f0ac748559"
        ),
        .target(
            name: "EstimotePositioningWrapper",
            dependencies: [
                "EstimotePositioningSDK",
                .product(name: "EstimoteSDK", package: "estimote-sdk-ios")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
