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
    case testGet
    case testPost(id: Int)
}

extension API: TargetType {
    var baseURL: URL {
        // FIXME: TBD
        return URL(string: "https://api.example.com")!
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
         if let accessToken = NetworkManager.shared.accessToken {
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
