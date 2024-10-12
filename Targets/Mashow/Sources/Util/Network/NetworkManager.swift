//
//  NetworkManager.swift
//  Mashow
//
//  Created by Kai Lee on 7/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Moya

final class NetworkManager<Target> where Target: TargetType {
    private(set) var provider: MoyaProvider<Target>
    private let lock = NSLock()
    private var plugins: [PluginType] = []
    
    init(provider: MoyaProvider<Target> = MoyaProvider<Target>()) {
        self.provider = provider
        self.plugins = provider.plugins
    }
    
    // MARK: Manage access token
    func registerAccessToken(accessToken: String) {
        lock.lock()
        defer { lock.unlock() }
        
        updateProvider(with: BearerTokenPlugin(accessToken: accessToken))
    }
    
    func removeAccessToken() {
        lock.lock()
        defer { lock.unlock() }
        
        updateProvider(removeBearerToken: true)
    }
    
    // MARK: API Request
    @discardableResult
    func request(_ api: Target) async throws -> Response {
        try await provider.request(api)
    }
    
    func request<T>(_ api: Target, of type: T.Type) async throws -> T where T: Decodable {
        try await request(api).map(T.self)
    }
}

// MARK: - Private
private extension NetworkManager {
    func updateProvider(with newPlugin: PluginType? = nil, removeBearerToken: Bool = false) {
        plugins = plugins.withoutBearerTokenPlugins
        
        if let newPlugin = newPlugin {
            plugins.append(newPlugin)
        }
        
        provider = MoyaProvider<Target>(
            endpointClosure: provider.endpointClosure,
            requestClosure: provider.requestClosure,
            stubClosure: provider.stubClosure,
            session: provider.session,
            plugins: plugins,
            trackInflights: provider.trackInflights
        )
    }
}

// MARK: - Token Plugin
final class BearerTokenPlugin: PluginType {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    /// Add Authorization Header
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

private extension [PluginType] {
    var withoutBearerTokenPlugins: [PluginType] {
        filter { !($0 is BearerTokenPlugin) }
    }
}
