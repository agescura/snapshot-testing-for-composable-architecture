// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "snapshot-testing-for-composable-architecture",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SnapshotTestingComposableArchitecture",
            targets: ["SnapshotTestingComposableArchitecture"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.2"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "SnapshotTestingComposableArchitecture",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
