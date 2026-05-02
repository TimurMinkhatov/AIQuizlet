import ProjectDescription

let cocoapodsDependencies = CocoapodsDependencies(
    repos: [
        "https://cdn.cocoapods.org/"
    ],
    dependencies: [
        .cdn(name: "RecaptchaInterop", requirement: .upToNextMajor("100.0.0")),
        .cdn(name: "SnapKit", requirement: .exact("5.7.1")),
        .cdn(name: "SwiftGen", requirement: .upToNextMajor("6.6.0")) 
    ]
)

let dependencies = Dependencies(cocoapods: cocoapodsDependencies)
