// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription

let package = Package(
    name: "SpatialContinuityShared",
    platforms: [
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpatialContinuityShared",
            targets: ["SpatialContinuityShared"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/finnvoor/Transcoding", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpatialContinuityShared",
            dependencies: ["Transcoding"]
        )
    ]
)
