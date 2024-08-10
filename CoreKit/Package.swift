// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppConfiguration",
            targets: ["AppConfiguration"]),
        .library(
            name: "DesignerSystem",
            targets: ["DesignerSystem"]),
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]),
        .library(
            name: "Router",
            targets: ["Router"]),
        .library(
            name: "Scheme",
            targets: ["Scheme"]),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
        .library(
            name: "UIUtilities",
            targets: ["UIUtilities"]),
        .library(
            name: "Utilities",
            targets: ["Utilities"]),
    ],
    // MARK: - Dependencies Frameworks
    dependencies: [
        // Lottie
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            .upToNextMajor(from: "4.0.0")
        ),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppConfiguration"),
        .target(
            name: "DesignerSystem",
            dependencies: []),
        .target(
            name: "NetworkLayer",
            dependencies: ["AppConfiguration", "SharedModels"]),
        .target(
            name: "Router",
            dependencies: []),
        .target(
            name: "Scheme",
            dependencies: []),
        .target(
            name: "SharedModels",
            dependencies: ["Scheme"]),
        .target(
            name: "UIUtilities",
            dependencies: [
                "DesignerSystem",
                "Scheme",
                "SharedModels",
                .product(name: "Lottie", package: "lottie-ios")
            ]),
        .target(
            name: "Utilities",
            dependencies: []),

        // MARK: - Tests
        .testTarget(
            name: "NetworkLayerTests",
            dependencies:  ["NetworkLayer", "AppConfiguration", "SharedModels"]),
        .testTarget(
            name: "UtilitiesTests",
            dependencies:  ["Utilities"])

    ]
)
