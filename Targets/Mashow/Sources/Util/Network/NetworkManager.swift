//
//  NetworkManager.swift
//  Mashow
//
//  Created by Kai Lee on 7/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

final class NetworkManager<Target> where Target: TargetType {
    init(provider: MoyaProvider<Target> = MoyaProvider<Target>()) {
        self.provider = provider
    }
    
    private let provider: MoyaProvider<Target>
    private(set) var accessToken: String?
    
    // MARK: - Manage access token
    func registerAccessToken(token: String) {
        accessToken = token
    }
    
    func removeAccessToken() {
        accessToken = nil
    }
    
    // MARK: - API Request
    func request<T>(_ api: Target, of type: T.Type) async throws -> T where T: Decodable {
        try await provider
            .request(api)
            .map(T.self)
    }
}
