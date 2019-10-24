// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoLayout",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "AutoLayout", targets: ["AutoLayout"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AutoLayout",
            path: "./AutoLayout/"
        )
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
