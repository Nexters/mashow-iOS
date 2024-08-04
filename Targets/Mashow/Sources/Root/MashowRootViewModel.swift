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

    let state: State
    
    /// State: 상태저장. 기본적으로 상태를 저장 및 방출할 수 있음(`CurrentValueSubject`)
    struct State {
        let accessToken: CurrentValueSubject<String?, Never>
    }
        
    init(_ storageManager: StorageManager = Environment.storage) {
        self.storageManager = storageManager
        storageManager.accessToken = nil // TODO: Should be deleted
        
        let storedAccessToken = storageManager.accessToken
        self.state = State(
            accessToken: CurrentValueSubject<String?, Never>(storedAccessToken)
        )
    }
    
    func saveTokenToStorage(accessToken: String?) {
        self.storageManager.accessToken = accessToken
    }
}
