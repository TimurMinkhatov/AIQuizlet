import ProjectDescription

let cocoapodsDependencies = CocoapodsDependencies(
    repos: [
        "https://cdn.cocoapods.org/"
    ],
    dependencies: [
        .cdn(name: "Firebase/Auth", requirement: .exact("10.29.0")),
        .cdn(name: "RecaptchaInterop", requirement: .upToNextMajor("100.0.0")),
        .cdn(name: "SnapKit", requirement: .exact("5.7.1"))
    ]
)

let dependencies = Dependencies(cocoapods: cocoapodsDependencies)
