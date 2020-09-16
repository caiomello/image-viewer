// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ImageViewer",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ImageViewer",
            targets: ["ImageViewer"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "ImageViewer",
            dependencies: []),
        .testTarget(
            name: "ImageViewerTests",
            dependencies: ["ImageViewer"]),
    ]
)
