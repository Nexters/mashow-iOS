//
//  NetworkMangerTests.swift
//  MashowTests
//
//  Created by Kai Lee on 7/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import XCTest
import Moya
@testable import Mashow

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager<TestAPI>!
    
    override func setUpWithError() throws {
        let stubbingProvider = MoyaProvider<TestAPI>(stubClosure: MoyaProvider.immediatelyStub)
        networkManager = NetworkManager(provider: stubbingProvider)
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    func testRegisterAccessToken() {
        let token = "testAccessToken"
        
        networkManager.registerAccessToken(accessToken: token)
        
        // Create a request to test the header
        let request = URLRequest(url: URL(string: "https://api.example.com/get")!)
        let plugins = networkManager.provider.plugins
            .filter { $0 is BearerTokenPlugin }
        XCTAssertEqual(plugins.count, 1, "There should be plugin.")
        
        let preparedRequest = plugins.first?.prepare(request, target: TestAPI.testGet)
        XCTAssertEqual(
            preparedRequest?.value(forHTTPHeaderField: "Authorization"),
            "Bearer \(token)", 
            "Access token should be correctly added to the Authorization header.")
    }
    
    func testRegisterAccessTokenTwice() {
        let token = "testAccessToken"
        
        networkManager.registerAccessToken(accessToken: token)
        networkManager.registerAccessToken(accessToken: token)
        
        // Create a request to test the header
        let plugins = networkManager.provider.plugins
            .filter { $0 is BearerTokenPlugin }
        XCTAssertEqual(plugins.count, 1, "There should be only one plugin.")
    }
    
    func testRemoveAccessToken() {
        networkManager.registerAccessToken(accessToken: "testAccessToken")
        let plugins = networkManager.provider.plugins
            .filter { $0 is BearerTokenPlugin }
        XCTAssertEqual(plugins.count, 1, "There should be plugin.")
        
        networkManager.removeAccessToken()
        let hasBearerTokenPlugin = networkManager.provider.plugins
            .filter { $0 is BearerTokenPlugin }
            .isNotEmpty
        
        XCTAssertFalse(hasBearerTokenPlugin, "Access token plugin should be removed.")
    }
    
    func testRequestSuccess() async throws {
        let expectedResult = testData
        let apiEndpoint = TestAPI.testGet
        
        do {
            let result = try await networkManager.request(apiEndpoint, of: TestData.self)
            XCTAssertEqual(result, expectedResult, "The result should match the expected result.")
        } catch {
            XCTFail("Request should succeed, but it failed with error: \(error).")
        }
    }
    
    func testRequestFailure() async {
        let stubbingProvider = MoyaProvider<TestAPI>(
            endpointClosure: failureEndpointClosure,
            stubClosure: MoyaProvider.immediatelyStub)
        networkManager = NetworkManager(provider: stubbingProvider)
        
        let apiEndpoint = TestAPI.testGet

        do {
            let _: TestData = try await networkManager.request(apiEndpoint, of: TestData.self)
            XCTFail("Request should fail, but it succeeded.")
        } catch {
            // Expect error
        }
    }
    
    // Helper to simulate request failure
    private func failureEndpointClosure(_ target: TestAPI) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkError(NSError(domain: "Network error", code: 500, userInfo: nil)) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
}

// MARK: - Test API
extension NetworkManagerTests {
    enum TestAPI: TargetType {
        case testGet
        
        var method: Moya.Method {
            .get
        }
        
        var task: Task {
            .requestPlain
        }
        
        var headers: [String: String]? {
            ["Content-Type": "application/json"]
        }
        
        var path: String { "/get" }
        
        var sampleData: Data {
            jsonString.data(using: .utf8)!
        }
        
        var baseURL: URL {
            URL(string: "https://api.example.com")!
        }
    }
}

// MARK: - Test data
fileprivate struct TestData: Decodable, Equatable {
    let data: String
}

fileprivate let jsonString = """
{
  "data": "testGet"
}
"""

fileprivate let testData = TestData(data: "testGet")

extension Array {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
