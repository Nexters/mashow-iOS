//
//  API.swift
//  Mashow
//
//  Created by Kai Lee on 7/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

enum API {
    case user(UsertAPI)
    case history(HistoryAPI)
}

extension API: TargetType {
    var baseURL: URL {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_API_URL") as? String else {
            fatalError("XCConfig을 잘못 넣으셨군요...")
        }
        
        return URL(string: baseUrl)!
    }
    
    /// - Note: Access Token은 `NetworkManager`에서 더해서 보낼 것이므로 여기선 걱정할 거 없음
    var headers: [String : String]? {
        var header = ["Content-type": "application/json"]
        return header
    }
    
    var path: String {
        switch self {
        case .user(let api): api.path
        case .history(let api): api.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .user(let api): api.method
        case .history(let api): api.method
        }
    }
    
    var task: Task {
        switch self {
        case .user(let api): api.task
        case .history(let api): api.task
        }
    }
    var sampleData: Data {
        switch self {
        case .user(let api): api.sampleData
        case .history(let api): api.sampleData
        }
    }
}
