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
    /// - Returns: 성공 시 액세스 토큰을 반환함.
    func signIn(with platform: PlatformType) async throws -> String {
        let mashowAccessToken: String
        
        switch platform {
        case .apple(let viewController):
            // FIXME: API 나오면 아래 부분 수정
            mashowAccessToken = try await signInWithApple(viewController)
        case .kakao:
            // FIXME: API 나오면 아래 부분 수정
            let accessToken = try await signInWithKakao()
            mashowAccessToken = try await networkManager.request(.testPost(id: 123), of: String.self)
        }
        return mashowAccessToken
    }
}

extension AuthorizationManager {
    enum PlatformType {
        case apple(UIViewController)
        case kakao
    }
}
