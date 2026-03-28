import ProjectDescription

let project = Project(
    name: "AIQuizlet",
    organizationName: "t-bank-team-practice",
    targets: [
        Target(
            name: "AIQuizlet",
            destinations: .iOS,
            product: .app,
            bundleId: "com.aiquizlet.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "FirebaseAppDelegateProxyEnabled": false
                ]
            ),
            sources: ["AIQuizlet/Sources/**"],
            resources: ["AIQuizlet/Resources/**"],
            scripts: [
                .pre(
                    script: """
                    if test -f /usr/local/bin/swiftlint; then
                        /usr/local/bin/swiftlint
                    else
                        echo "SwiftLint not installed"
                    fi
                    """,
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "FirebaseAuth")
            ],
            settings: .settings(
                base: ["VALIDATE_WORKSPACE": "NO"]
            )
        ),
        Target(
            name: "AIQuizletTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.aiquizlet.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["AIQuizletTests/**"],
            dependencies: [
                .target(name: "AIQuizlet")
            ]
        )
    ]
)
