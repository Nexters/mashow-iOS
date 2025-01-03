import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    private static let organizationName = "com.alcoholers"
    private static let projectName = "Mashow"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: self.organizationName,
                       targets: targets)
    }
    
    // MARK: - Private
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .framework,
                             bundleId: "\(organizationName).\(name)",
                             deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
                             infoPlist: .default,
                             sources: ["Targets/\(name)/Sources/**"])
        
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "\(organizationName).\(name)Tests",
                           deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
                           infoPlist: .default,
                           sources: ["Targets/\(name)/Tests/**"],
                           resources: [],
                           dependencies: [.target(name: name)])
        
        return [sources, tests]
    }
    
    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ],
                    ]
                ],
            ],
            "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "kakaoplus", "kakaotalk"],
            "NSAppTransportSecurity": [
                "NSAllowsArbitraryLoads": true
            ],
            "UIAppFonts": [
                "Pretendard-Black.otf",
                "Pretendard-Bold.otf",
                "Pretendard-ExtraBold.otf",
                "Pretendard-ExtraLight.otf",
                "Pretendard-Light.otf",
                "Pretendard-Medium.otf",
                "Pretendard-Regular.otf",
                "Pretendard-SemiBold.otf",
                "Pretendard-Thin.otf",
                "BlankSans-bold.otf",
                "Road_Rage.otf"
            ],
            "CFBundleURLTypes": [
                [
                    "CFBundleTypeRole": "Editor",
                    "CFBundleURLSchemes": [
                        "kakao$(KAKAO_APP_KEY)"
                    ]
                ]
            ],
            "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
            "BASE_API_URL": "$(BASE_API_URL)",
            "GPT_KEY": "$(GPT_KEY)",
            "CFBundleShortVersionString": "$(MARKETING_VERSION)",
            "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
            "NSCameraUsageDescription": "라벨 정보를 인식하기 위해 카메라가 필요합니다. 기능을 사용하기 위해선 권한을 허용해주세요."
        ]
        
        let debugConfiguration = Configuration.debug(
            name: .debug,
            xcconfig: .relativeToRoot("Configurations/Debug.xcconfig"))
        
        let releaseConfiguration = Configuration.release(
            name: .release,
            xcconfig: .relativeToRoot("Configurations/Release.xcconfig")
        )

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            entitlements: .file(path: "./Mashow.entitlements"),
            dependencies: dependencies + [
                .external(name: "SnapKit"),
                .external(name: "Moya"),
                .external(name: "Kingfisher"),
                .external(name: "Lottie"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "Willow")
            ],
            settings: .settings(configurations: [
               debugConfiguration,
               releaseConfiguration
            ])
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        return [mainTarget, testTarget]
    }
}
