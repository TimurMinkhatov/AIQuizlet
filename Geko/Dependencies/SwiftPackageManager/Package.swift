// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "AIQuizlet",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0"))
    ]
)
