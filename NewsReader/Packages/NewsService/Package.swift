// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NewsService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NewsService",
            targets: ["NewsService"]),
    ],
    dependencies: [
        .package(path: "../DataTypes")
    ],
    targets: [
        .target(
            name: "NewsService",
            dependencies: [
                .product(name: "DataTypes", package: "DataTypes")
            ]
        ),
        .testTarget(
            name: "NewsServiceTests",
            dependencies: ["NewsService"]
        ),
    ]
)
