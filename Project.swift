import ProjectDescription

let project = Project(
    name: "AIQuizlet",
    targets: [
        Target(
            name: "AIQuizlet",
            destinations: .iOS,
            product: .app,
            bundleId: "com.azamat.AIQuizlet",
            infoPlist: .default,
            sources: ["AIQuizlet/**"],
            resources: ["AIQuizlet/**/*.xcassets"],
            dependencies: []
        )
    ]
)
