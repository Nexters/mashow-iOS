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
    let nickname: String
    let accessToken: String
}

extension User {
    var sampleData: Data {
        let rawString = """
{
  "code": 0,
  "message": "string",
  "value": {
    "nickname": "알렉스",
    "accessToken": "{accessToken}"
  }
}
"""
        return try! JSONEncoder().encode(rawString)
    }
}
