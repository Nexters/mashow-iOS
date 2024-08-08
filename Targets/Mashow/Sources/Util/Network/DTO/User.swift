//
//  User.swift
//  MashowTests
//
//  Created by Kai Lee on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct UserResponse: Decodable {
    let code: Int
    let message: String
    let value: User?
}

struct User: Codable {
    let userId: Int
    let nickname: String
    let oAuthProvider: String
    let accessToken: String
    let createdAt: String
    let modifiedAt: String
}

extension User {
    var sampleData: Data {
        let rawString = """
{
  "code": 0,
  "message": "string",
  "value": {
    "userId": 1,
    "nickname": "알렉스",
    "oAuthProvider": "KAKAO",
    "oAuthIdentity": "3639122460",
    "accessToken": "{accessToken}",
    "createdAt": "2024-08-05T12:04:00.019Z",
    "modifiedAt": "2024-08-05T12:04:00.019Z"
  }
}
"""
        return try! JSONEncoder().encode(rawString)
    }
}
