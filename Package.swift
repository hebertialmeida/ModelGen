// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ModelGen",
    products: [
        .executable(name: "modelgen", targets: ["ModelGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.1"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.7.2"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.1"),
    ],
    targets: [
        .target(name: "ModelGen", dependencies: [
            "Commander",
            "PathKit",
            "Stencil",
            "StencilSwiftKit",
            "Yams"
        ], path: "Sources")
    ]
)
