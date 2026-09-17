// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Coordination",
    platforms: [.iOS(.v16)],
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
