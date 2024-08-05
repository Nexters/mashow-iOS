//
//  AuthorizationManager.swift
//  MashowTests
//
//  Created by Kai Lee on 7/24/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit

struct AuthorizationManager {
    private let networkManager: NetworkManager<API>
    
    init(
        _ networkManager: NetworkManager<API> = Environment.network
    ) {
        self.networkManager = networkManager
    }
    
    /// Platform 별로 로그인 요청 후 성공하면 서버에 액세스 토큰을 요청함.
    /// - Returns: 성공 시 `User` 객체를 반환함.
    func signIn(with platform: PlatformType) async throws -> (oAuthTokenm: String, user: User?) {
        let oAuthToken: String
        
        switch platform {
        case .apple:
            oAuthToken = try await signInWithApple()
        case .kakao:
            oAuthToken = try await signInWithKakao()
        }
        
        let userResponse = try await networkManager.request(
            .account(.logIn(platform: platform, oAuthToken: oAuthToken)),
            of: UserResponse.self
        )
        
        return (oAuthToken, userResponse.value)
    }
}

extension AuthorizationManager {
    enum PlatformType {
        case apple
        case kakao
        
        var apiParameter: String {
            switch self {
            case .apple:
                return "APPLE"
            case .kakao:
                return "KAKAO"
            }
        }
    }
}
