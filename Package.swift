// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AsyncView",
    platforms: [.iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "AsyncView",
            targets: ["AsyncView"]
        ),
    ],
    dependencies: [.package(url: "https://github.com/nashysolutions/Cache.git", .upToNextMinor(from: "3.0.0"))],
    targets: [
        .target(
            name: "AsyncView",
            dependencies: ["Cache"]
        ),
    ]
)
