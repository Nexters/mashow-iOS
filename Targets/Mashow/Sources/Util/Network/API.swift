//
//  API.swift
//  Mashow
//
//  Created by Kai Lee on 7/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

// FIXME: 나중에 API 나오는 거에 맞춰서 전부 변경해야 함
enum API {
    case testGet
    case testPost(id: Int)
}

extension API: TargetType {
    var baseURL: URL {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_API_URL") as? String else {
            fatalError("XCConfig을 잘못 넣으셨군요...")
        }
        
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .testGet:
            return "/get"
        case .testPost:
            return "/post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .testGet:
            return .get
        case .testPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .testGet:
            return .requestPlain
        case .testPost(id: let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = ["Content-type": "application/json"]
        // Add authorization headers if exists
        if let accessToken = Environment.network.accessToken {
             header["Authorization"] = "Bearer \(accessToken)"
         }
        
        return header
    }
    
    var sampleData: Data {
        switch self {
        case .testGet:
            return Data() // Provide sample data for testing
        case .testPost:
            return Data() // Provide sample data for testing
        }
    }
}
