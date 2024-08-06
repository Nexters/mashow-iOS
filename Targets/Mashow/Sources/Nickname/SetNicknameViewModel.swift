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
    
    func setNickname(_ nickname: String) async throws {
        let accessToken = try await networkManager.request(
            .account(.signUp(
                platform: state.platform,
                oAuthToken: state.platformOAuthToken,
                nickname: nickname)),
            of: String.self
        )
        
        // Report to publisher
        state.accessToken.send(accessToken)
    }
}
