//
//  Dependencies.swift
//  Config
//
//  Created by Kai Lee on 7/14/24.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        // SnapKit
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1")),
        // Kingfisher
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        // Lottie
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "3.4.3"))
    ],
    platforms: [.iOS]
)
