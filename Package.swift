// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ISHPullUp",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "ISHPullUp",
            targets: ["ISHPullUp"]
        ),
    ],
    targets: [
        .target(
            name: "ISHPullUp",
            path: "ISHPullUp",
            publicHeadersPath: "."
        )
    ]
)
