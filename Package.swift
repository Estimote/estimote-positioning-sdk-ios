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
            targets: ["EstimotePositioningSDK"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Estimote/estimote-sdk-ios.git",
            .upToNextMinor(from: "2.0.0"))
    ],
    targets: [
        .binaryTarget(
            name: "EstimotePositioningSDKBinary",
            url: "https://github.com/Estimote/estimote-positioning-sdk-ios/releases/download/v1.0.0-beta/EstimotePositioningSDK.xcframework.zip",
            checksum: "e46904b150fcf565c542c3f696e233cc2d032aa2ed572f8d5cac55d7a19a2f97"
        ),
        .target(
            name: "EstimotePositioningSDK",
            dependencies: [
                "EstimotePositioningSDKBinary",
                .product(name: "EstimoteSDK", package: "estimote-sdk-ios")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
