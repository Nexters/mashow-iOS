//
//  Dependencies.swift
//  Config
//
//  Created by Kai Lee on 7/14/24.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            // SnapKit
            .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
            // Moya (포크 버전)
            .package(url: "https://github.com/enebin/Moya-iOS12.git", .upToNextMinor(from: "1.0.0")),
            // Kingfisher
            .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
            // Lottie
            .package(url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.4.3")),
            // Kakao
            .package(url: "https://github.com/kakao/kakao-ios-sdk.git", .upToNextMajor(from: "2.22.5")),
            // Logger(Willow)
            .package(url: "https://github.com/Nike-Inc/Willow.git", .upToNextMajor(from: "5.2.1"))
        ]
    ),
    platforms: [.iOS]
)
