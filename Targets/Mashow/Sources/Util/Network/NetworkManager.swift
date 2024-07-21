//
//  NetworkManager.swift
//  Mashow
//
//  Created by Kai Lee on 7/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {
        // Use singleton instead
    }
    
    private let provider = MoyaProvider<API>()
    private(set) var accessToken: String?
    
    // MARK: - Manage access token
    func registerAccessToken(token: String) {
        accessToken = token
    }
    
    func removeAccessToken() {
        accessToken = nil
    }
    
    // MARK: - API Request
    func request<T>(_ api: API, of type: T.Type) async throws -> T where T: Decodable {
        try await provider
            .request(api)
            .map(T.self)
    }
}
