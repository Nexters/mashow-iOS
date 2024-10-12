//
//  RecordDetail.swift
//  Mashow
//
//  Created by Kai Lee on 9/27/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct RecordDetailResponse: Codable {
    let code: Int
    let message: String
    let value: RecordDetail
}

struct RecordDetail: Codable {
    let liquorHistoryId: Int
    let liquors: [Liquor]
    let drankAt: String
    let rating: Int
    let memos: [Memo]
    let sideDishes: [SideDish]
    
    struct Liquor: Codable {
        let liquorType: String
        let details: [LiquorDetail]
    }
    
    struct LiquorDetail: Codable {
        let names: String
    }
    
    struct Memo: Codable {
        let description: String
    }
    
    struct SideDish: Codable {
        let names: String
    }
}
