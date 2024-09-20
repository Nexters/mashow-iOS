//
//  RecordListResponse.swift
//  Mashow
//
//  Created by Kai Lee on 9/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct RecordListResponse: Codable {
    let code: Int
    let message: String
    let value: Value
    
    struct Value: Codable {
        let totalPageNumber: Int
        let currentPageIndex: Int
        let pageSize: Int
        let isLastPage: Bool
        let totalElementNumber: Int
        let contents: [Content]
        
        struct Content: Codable {
            let year: Int
            let month: Int
            let histories: [History]
            
            struct History: Codable {
                let drankAt: String
                let liquorDetailNames: [String]
            }
        }
    }
}
