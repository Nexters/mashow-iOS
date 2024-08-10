//
//  SetNicknameViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Combine
import Foundation

final class SetNicknameViewModel {
    struct State {
        let platform: AuthorizationManager.PlatformType
        let platformOAuthToken: String
        let accessToken: CurrentValueSubject<String?, Never>
    }
    
    let state: State
    private let networkManager: NetworkManager<API>
    
    init(
        state: State,
        _ networkManager: NetworkManager<API> = Environment.network
    ) {
        self.state = state
        self.networkManager = networkManager
    }
    
    /// Register에 성공하면 accessToken을 리턴합니다
    func register(nickname: String) async throws -> String {
        let user = try await networkManager.request(
            .user(.signUp(
                platform: state.platform,
                oAuthToken: state.platformOAuthToken,
                nickname: nickname)),
            of: UserResponse.self
        ).value
        
        guard let user else {
            throw URLError(.badServerResponse)
        }
        
        return user.accessToken
    }
}
