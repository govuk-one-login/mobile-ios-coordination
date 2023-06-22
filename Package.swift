// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coordination",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Coordination", targets: ["Coordination"])
    ],
    dependencies: [ ],
    targets: [
        .target(name: "Coordination",
                swiftSettings: [
                    .define("DEBUG", .when(configuration: .debug))
                ]
               ),
        .testTarget(name: "CoordinationTests", dependencies: ["Coordination"])
    ]
)
