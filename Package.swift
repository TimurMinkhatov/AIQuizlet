// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AIQuizlet",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0")
    ],
    targets: [
        .target(
            name: "AIQuizlet",
            dependencies: [
                .product(name: "Moya", package: "Moya"),
                .product(name: "CombineMoya", package: "Moya"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "AIQuizlet"
        )
    ]
)
