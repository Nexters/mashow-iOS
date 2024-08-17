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
    
    func validateUser(with accessToken: String) async -> User? {
        // FIXME: Connect API when it's done
//        networkManager.request(.user, of: UserResponse.self)
        return User(nickname: "Temp", accessToken: accessToken)
    }
    
    func saveTokenToStorage(accessToken: String?) {
        self.storageManager.accessToken = accessToken
    }
}
