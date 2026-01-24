// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NewsAPIService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NewsAPIService",
            targets: ["NewsAPIService"]),
    ],
    dependencies: [
        .package(path: "../NewsService"),
        .package(path: "../NetworkClient"),
        .package(path: "../DataTypes")
    ],
    targets: [
        .target(
            name: "NewsAPIService",
            dependencies: [
                .product(name: "NewsService", package: "NewsService"),
                .product(name: "NetworkClient", package: "NetworkClient"),
                .product(name: "DataTypes", package: "DataTypes")
            ]
        ),
        .testTarget(
            name: "NewsAPIServiceTests",
            dependencies: ["NewsAPIService"]
        ),
    ]
)
