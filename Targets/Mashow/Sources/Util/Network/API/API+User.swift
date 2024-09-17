//
//  API+User.swift
//  Mashow
//
//  Created by Kai Lee on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

enum UsertAPI {
    case signUp(platform: AuthorizationManager.PlatformType, oAuthToken: String, nickname: String)
    case logIn(platform: AuthorizationManager.PlatformType, oAuthToken: String)
    case withdraw(accessToken: String)
    case fetch(accessToken: String)
}

extension UsertAPI: SubTargetType {
    var path: String {
        switch self {
        /// 회원가입
        case .signUp: "user/signup"
        /// 로그인
        case .logIn: "user/login"
        /// 탈퇴
        case .withdraw: "user/account"
        /// 조회
        case .fetch: "user/fetch-login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .logIn, .fetch:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .signUp(platform, oAuthToken, nickname):
            return .requestParameters(
                parameters: [
                    "provider": platform.apiParameter,
                    "oAuthToken": oAuthToken,
                    "nickname": nickname
                ],
                encoding: JSONEncoding.default
            )
        case let .logIn(platform, oAuthToken):
            return .requestParameters(
                parameters: [
                    "provider": platform.apiParameter,
                    "oAuthToken": oAuthToken
                ],
                encoding: JSONEncoding.default
            )
        case let .fetch(accessToken):
            return .requestParameters(
                parameters: [
                    "accessToken": accessToken
                    ],
                encoding: JSONEncoding.default
            )
        case let .withdraw(accessToken):
            return .requestParameters(
                parameters: [
                    "accessToken": accessToken
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var sampleData: Data {
        switch self {
        case .signUp:
            return Data()
        case .logIn:
            return Data()
        case .fetch:
            return Data()
        case .withdraw:
            return Data()
        }
    }
}
