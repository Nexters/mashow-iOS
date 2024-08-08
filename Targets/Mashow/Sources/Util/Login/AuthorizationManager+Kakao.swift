//
//  AuthorizationManager+Kakao.swift
//  Mashow
//
//  Created by Kai Lee on 7/24/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

extension AuthorizationManager {
    /// 카카오 로그인 요청 후 카카오 액세스 토큰을 반환한다
    @MainActor func signInWithKakao() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            // 카카오톡 앱 사용 가능 여부 확인
            if UserApi.isKakaoTalkLoginAvailable() {
                // 앱 있으면 앱으로
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        guard let token = oauthToken?.accessToken else {
                            continuation.resume(throwing: URLError(.badServerResponse))
                            return
                        }
                        
                        continuation.resume(returning: token)
                    }
                }
            } else {
                // 앱 없으면 웹으로
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        guard let token = oauthToken?.accessToken else {
                            continuation.resume(throwing: URLError(.badServerResponse))
                            return
                        }
                        
                        continuation.resume(returning: token)
                    }
                }
            }
        }
    }
}
