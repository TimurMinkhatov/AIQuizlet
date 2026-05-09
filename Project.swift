import ProjectDescription

let project = Project(
    name: "AIQuizlet",
    organizationName: "t-bank-practice-team",
    targets: [
        .target(
            name: "AIQuizlet",
            destinations: .iOS,
            product: .app,
            bundleId: "com.aiquizlet.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "NSCameraUsageDescription": "Нам нужен доступ к камере, чтобы вы могли сфотографировать конспект для создания теста.",
                    "NSPhotoLibraryUsageDescription": "Нам нужен доступ к галерее, чтобы вы могли выбрать готовое фото конспекта для создания теста.",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "FirebaseAppDelegateProxyEnabled": false,
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
                    ]
                ]
            ),
            sources: ["AIQuizlet/Sources/**"],
            resources: ["AIQuizlet/Resources/**"],
            scripts: [
                .pre(
                    script: """
                    if test -f /usr/local/bin/swiftlint; then
                        /usr/local/bin/swiftlint
                    elif test -f /opt/homebrew/bin/swiftlint; then
                        /opt/homebrew/bin/swiftlint
                    else
                        echo "SwiftLint not installed"
                    fi
                    """,
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                ),
                .pre(
                    script: """
                    if test -f /opt/homebrew/bin/swiftgen; then
                        /opt/homebrew/bin/swiftgen config run --config "${SRCROOT}/swiftgen.yml"
                    else
                        echo "warning: SwiftGen not installed"
                    fi
                    """,
                    name: "SwiftGen",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseFirestore"),
            ],
            settings: .settings(
                base: [
                    "VALIDATE_WORKSPACE": "NO",
                    "CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER": "NO",
                    "GCC_WARN_INHIBIT_ALL_WARNINGS": "YES",
                    "OTHER_LDFLAGS": "$(inherited) -ObjC"
                ]
            )
        ),
        .target(
            name: "AIQuizletTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.aiquizlet.app.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["AIQuizletTests/**"],
            dependencies: [
                .target(name: "AIQuizlet")
            ]
        )
    ]
)
