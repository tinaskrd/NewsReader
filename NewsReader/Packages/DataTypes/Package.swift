// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataTypes",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DataTypes",
            targets: ["DataTypes"]),
    ],
    targets: [
        .target(
            name: "DataTypes"),
        .testTarget(
            name: "DataTypesTests",
            dependencies: ["DataTypes"]),
    ]
)
