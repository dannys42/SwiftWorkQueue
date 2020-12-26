// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkQueue",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WorkQueue",
            targets: ["WorkQueue"]),
        .library(name: "WorkQueueDispatch",
                 targets: ["WorkQueueDispatch"]),
        .library(name: "WorkQueueOperation",
                 targets: ["WorkQueueOperation"]),
        .library(name: "WorkQueueRunLoop",
                 targets: ["WorkQueueRunLoop"]),
        .library(name: "WorkQueueTestUtilities",
                 targets: ["WorkQueueTestUtilities"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WorkQueue",
            dependencies: []),
        .target(
            name: "WorkQueueDispatch",
            dependencies: [ "WorkQueue" ]),
        .target(
            name: "WorkQueueOperation",
            dependencies: [ "WorkQueue" ]),
        .target(
            name: "WorkQueueRunLoop",
            dependencies: [ "WorkQueue" ]),
        .target(name: "WorkQueueTestUtilities",
                dependencies: [ "WorkQueue" ]),

        .testTarget(
            name: "WorkQueueTests",
            dependencies: ["WorkQueue"]),
        .testTarget(
            name: "WorkQueueDispatchTests",
            dependencies: [ "WorkQueue", "WorkQueueDispatch", "WorkQueueTestUtilities" ]),
        .testTarget(
            name: "WorkQueueOperationTests",
            dependencies: [ "WorkQueue", "WorkQueueOperation", "WorkQueueTestUtilities" ]),
        .testTarget(
            name: "WorkQueueRunLoopTests",
            dependencies: [ "WorkQueue", "WorkQueueRunLoop", "WorkQueueTestUtilities" ]),
    ]
)
