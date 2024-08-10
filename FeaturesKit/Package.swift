// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeaturesKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PopularMovies",
            targets: ["PopularMovies"]),
    ],

    // MARK: - Dependencies Frameworks

    dependencies: [
        .package(name: "CoreKit", path: "../CoreKit"),
        // WebP Images
        .package(
            url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git",
            .upToNextMajor(from: "3.0.0")
        ),

    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PopularMovies",
            dependencies: [
                .product(name: "AppConfiguration", package: "CoreKit"),
                .product(name: "DesignerSystem", package: "CoreKit"),
                .product(name: "NetworkLayer", package: "CoreKit"),
                .product(name: "Router", package: "CoreKit"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
                .product(name: "SharedModels", package: "CoreKit"),
                .product(name: "UIUtilities", package: "CoreKit"),
                .product(name: "Utilities", package: "CoreKit")
            ]),



        .testTarget(
            name: "MovieDetailsTests",
            dependencies:  [
                "PopularMovies",
                .product(name: "AppConfiguration", package: "CoreKit"),
                .product(name: "SharedModels", package: "CoreKit"),
            ]),
        .testTarget(
            name: "PopularMoviesTests",
            dependencies:  [
                "PopularMovies",
                .product(name: "AppConfiguration", package: "CoreKit"),
                .product(name: "SharedModels", package: "CoreKit"),
            ])
    ]
)
