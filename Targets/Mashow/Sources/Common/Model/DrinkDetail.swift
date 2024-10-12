//
//  DrinkDetail.swift
//  Mashow
//
//  Created by Kai Lee on 9/16/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

struct DrinkDetail: Codable {
    var liquors: [Liquor] = []
    var rating: Int?
    var sideDishes: [SideDish]?
    var memo: Memo?
}

extension DrinkDetail {
    struct Liquor: Codable {
        let liquorType: String
        let names: [String]
    }

    struct SideDish: Codable {
        let title: String
    }

    struct Memo: Codable {
        let description: String
    }
}
