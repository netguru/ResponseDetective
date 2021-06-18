// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ResponseDetective",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "ResponseDetective",
            targets: ["ResponseDetective"]
        ),
        .library(
            name: "ResponseDetectiveObjC",
            targets: ["ResponseDetectiveObjC"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ResponseDetective",
            dependencies: ["ResponseDetectiveObjC"],
            path: "ResponseDetective",
            sources: ["Sources/Swift"]
        ),
        .target(
            name: "ResponseDetectiveObjC",
            dependencies: [],
            path: "ResponseDetective",
            sources: ["Sources/ObjC"]
        )
//        .testTarget(
//            name: "ResponseDetectiveTests",
//            dependencies: ["ResponseDetective"],
//            path: "ResponseDetective",
//            sources: ["Tests"]
//        ),
    ]
)
