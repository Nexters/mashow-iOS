//
//  StorageManager.swift
//  MashowTests
//
//  Created by Kai Lee on 7/25/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

final class StorageManager {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: - 프로퍼티들
extension StorageManager {
    var accessToken: String? {
        get {
            userDefaults.string(forKey: StorageKey.accessToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKey.accessToken.rawValue)
        }
    }
}

// MARK: - Private
private extension StorageManager {
    enum StorageKey: String {
        case accessToken
    }
}
