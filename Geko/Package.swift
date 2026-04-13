// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AIQuizlet",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
    ],
    targets: [
        .target(
            name: "AIQuizlet",
            dependencies: [
                .product(name: "Moya", package: "Moya"),
                .product(name: "CombineMoya", package: "Moya"),
            ],
            path: "AIQuizlet"
        )
    ]
)
