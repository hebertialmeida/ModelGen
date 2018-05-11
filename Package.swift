// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ModelGen",
    products: [
        .executable(name: "modelgen", targets: ["ModelGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.11.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", .branchItem("master")),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.7.0"),
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