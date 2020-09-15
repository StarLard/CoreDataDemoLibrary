// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataDemoLibrary",
    platforms: [ .iOS(.v14), .macOS(.v11), .tvOS(.v14) ],
    products: [
        .library(
            name: "CoreDataDemoLibrary",
            targets: ["CoreDataDemoLibrary"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreDataDemoLibrary",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CoreDataDemoLibraryTests",
            dependencies: ["CoreDataDemoLibrary"]),
    ]
)
