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
        // Moya
        /// Note: Moya가 22년 이후로 관리가 안 되고 있어서 min iOS version이 아직도 v10으로 되어 있음
        /// 때문에 Moya를 포크해서 버전을 iOS 12로 올린 레포를 대신 사용함(코드 전부 동일한데 버전만 다름)
        .remote(url: "https://github.com/enebin/Moya-iOS12.git", requirement: .branch("master")),
        // Kingfisher
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        // Lottie
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "3.4.3"))
    ],
    platforms: [.iOS]
)
