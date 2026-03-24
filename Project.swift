import ProjectDescription

let project = Project(
    name: "AIQuizlet",
    organizationName: "t-bank team практика",
    targets: [
        Target(
            name: "AIQuizlet",
            destinations: [.iPhone],
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
                ),
                .pre(
                    script: """
                    if test -f /usr/local/bin/swiftgen; then
                        /usr/local/bin/swiftgen config run
                    else
                        echo "SwiftGen not installed"
                    fi
                    """,
                    name: "SwiftGen",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.0",
                    "IPHONEOS_DEPLOYMENT_TARGET": "17.0"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ],
                defaultSettings: .recommended
            )
        ),
        Target(
            name: "AIQuizletTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.azamat.AIQuizletTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["AIQuizletTests/**"],
            dependencies: [
                .target(name: "AIQuizlet")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "AIQuizlet",
            shared: true,
            buildAction: .buildAction(targets: ["AIQuizlet"]),
            runAction: .runAction(
                configuration: "Debug",
                executable: "AIQuizlet"
            )
        )
    ]
)
