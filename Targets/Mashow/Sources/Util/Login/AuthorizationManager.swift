//
//  AuthorizationManager.swift
//  MashowTests
//
//  Created by Kai Lee on 7/24/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

final class AuthorizationManager {
    private let networkManager: NetworkManager<API>
    private let storageManager: StorageManager
    
    /// 로그인 여부 판별 등에 사용되는 permanent 액세스 토큰.
    /// 내부에서 로그인 성공/로그아웃 시 자체적으로 업데이트 된다.
    private(set) var accessToken: String? {
        get {
            storageManager.accessToken
        }
        set {
            storageManager.accessToken = newValue
        }
    }
    
    init(
        _ storageManager: StorageManager = Environment.storage,
        _ networkManager: NetworkManager<API> = Environment.network
    ) {
        self.storageManager = storageManager
        self.networkManager = networkManager
    }
    
    /// Platform 별로 로그인 요청 후 성공하면 서버에 액세스 토큰을 요청함.
    /// - Returns: 성공 시 액세스 토큰을 반환함.
    func signIn(with platform: PlatformType) async throws -> String {
        let mashowAccessToken: String
        
        switch platform {
        case .apple:
            // FIXME: 잘 고쳐줘 다연아
            fatalError()
        case .kakao:
            // FIXME: API 나오면 아래 부분 수정
            let accessToken = try await signInWithKakao()
            mashowAccessToken = try await networkManager.request(.testPost(id: 123), of: String.self)
        }
        
        self.accessToken = mashowAccessToken
        return mashowAccessToken
    }
    
    func signOut() {
        accessToken = nil
    }
}

extension AuthorizationManager {
    enum PlatformType {
        case apple
        case kakao
    }
}
