//
//  LoginViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel {
    struct State {
        let accessToken: CurrentValueSubject<String?, Never>
    }
    
    let state: State
    private let authManager: AuthorizationManager

    init(state: State, _ authManager: AuthorizationManager = AuthorizationManager()) {
        self.state = state
        self.authManager = authManager
    }
    
    func signInWithApple() async throws {
        let accessToken = try await authManager.signInWithApple()
        // Report to publisher
        state.accessToken.send(accessToken)
    }
    
    func signInWithKakao() async throws {
        let accessToken = try await authManager.signInWithKakao()
        // Report to publisher
        state.accessToken.send(accessToken)
    }
}
