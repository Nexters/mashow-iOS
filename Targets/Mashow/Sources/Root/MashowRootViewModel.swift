//
//  MashowRootViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Combine

class MashowRootViewModel {
    private let storageManager: StorageManager
    private let networkManager: NetworkManager<API>

    let state: State
    
    /// State: 상태저장. 기본적으로 상태를 저장 및 방출할 수 있음(`CurrentValueSubject`)
    struct State {
        let accessToken: CurrentValueSubject<String?, Never>
        let nickname: CurrentValueSubject<String?, Never>
    }
        
    init(
        _ networkManager: NetworkManager<API> = Environment.network,
        _ storageManager: StorageManager = Environment.storage
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        let storedAccessToken = storageManager.accessToken
        self.state = State(
            accessToken: CurrentValueSubject<String?, Never>(storedAccessToken),
            nickname: CurrentValueSubject<String?, Never>(nil)
        )
    }
    
    func validateUser(with accessToken: String) async throws -> User {
        let response = try await networkManager.request(
            .user(.fetch(accessToken: accessToken)), of: UserFetchResponse.self)
        
        let fetchedUser = response.value
        return User(userId: fetchedUser.userId, nickname: fetchedUser.nickname, accessToken: accessToken)
    }
    
    func saveTokenToStorage(accessToken: String?) {
        storageManager.accessToken = accessToken
        if let accessToken {
            networkManager.registerAccessToken(accessToken: accessToken)
        }
    }
}
