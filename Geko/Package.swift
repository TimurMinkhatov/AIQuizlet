// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AIQuizlet",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0")
    ]
)
