// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "Moya": .staticFramework,
        "SnapKit": .framework,
        "FirebaseAuth": .staticFramework,
        "FirebaseFirestore": .staticFramework,
        "FBLPromises": .framework,
    ]
)
#endif

let package = Package(
    name: "AIQuizlet",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.29.0"),
    ]
)
