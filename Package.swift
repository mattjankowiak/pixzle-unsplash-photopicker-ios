// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swift-tools-version:5.6
let package = Package(
    name: "PixzleUnsplashPhotoPicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "PixzleUnsplashPhotoPicker",
            targets: ["PixzleUnsplashPhotoPicker"]
        ),
    ],
    targets: [
        .target(
            name: "PixzleUnsplashPhotoPicker",
            dependencies: [],
            path: "UnsplashPhotoPicker"
        )
    ]
)
