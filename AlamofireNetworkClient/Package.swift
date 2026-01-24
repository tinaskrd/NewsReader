// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlamofireNetworkClient",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AlamofireNetworkClient",
            targets: ["AlamofireNetworkClient"]),
    ],
    dependencies: [
        .package(path: "../NetworkClient"),
        .package(url: "https://github.com/Alamofire/Alamofire", exact: Version(5, 9, 1))
    ],
    targets: [
        .target(
            name: "AlamofireNetworkClient",
            dependencies: [
                .product(name: "NetworkClient", package: "NetworkClient"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "AlamofireNetworkClientTests",
            dependencies: ["AlamofireNetworkClient"]
        ),
    ]
)
