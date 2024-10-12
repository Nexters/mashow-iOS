//
//  LiquorTypeResponse.swift
//  Mashow
//
//  Created by Kai Lee on 9/16/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct LiquorTypesResponse: Codable {
    let code: Int
    let message: String
    let value: LiquorTypeValue
    
    struct LiquorTypeValue: Codable {
        let liquorHistoryTypes: [String]
    }
}
