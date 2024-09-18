//
//  DrinkType.swift
//  MashowTests
//
//  Created by Kai Lee on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

enum DrinkType: String, CaseIterable {
    case soju, liquor, makgeolli, sake, beer, wine, cocktail, highball
    
    var colorHexValues: [String] {
        switch self {
        case .soju:
            ["8EFFA7", "CCFFD1"]
        case .liquor:
            ["8EEBFF", "CCF3FF"]
        case .makgeolli:
            ["E2FF8E", "F2FFCC"]
        case .sake:
            ["FF8EED", "FFA9F1"]
        case .beer:
            ["FFC93F", "FFE040"]
        case .wine:
            ["DCA3FF", "F6DCFF"]
        case .cocktail:
            ["FFC46B", "FFF0BC"]
        case .highball:
            ["FFFA81", "FFFCBC"]
        }
    }
    
    var korean: String {
        switch self {
        case .soju:
            "소주"
        case .liquor:
            "양주"
        case .makgeolli:
            "막걸리"
        case .sake:
            "사케"
        case .beer:
            "맥주"
        case .wine:
            "와인"
        case .cocktail:
            "칵테일"
        case .highball:
            "하이볼"
        }
    }
    
    var tag: Int {
        switch self {
        case .soju:
            0
        case .liquor:
            1
        case .makgeolli:
            2
        case .sake:
            3
        case .beer:
            4
        case .wine:
            5
        case .cocktail:
            6
        case .highball:
            7
        }
    }
}

// MARK: - Network related

extension DrinkType {
    var forAPIParameter: String {
        switch self {
        case .soju:
            "SOJU"
        case .liquor:
            "LIQUOR"
        case .makgeolli:
            "MAKGEOLLI"
        case .sake:
            "SAKE"
        case .beer:
            "BEER"
        case .wine:
            "WINE"
        case .cocktail:
            "COCKTAIL"
        case .highball:
            "HIGHBALL"
        }
    }
    
    static func fromAPIResoponse(_ text: String) -> Self {
        switch text {
        case "SOJU":
            return .soju
        case "LIQUOR":
            return .liquor
        case "MAKGEOLLI":
            return .makgeolli
        case "SAKE":
            return .sake
        case "BEER":
            return .beer
        case "WINE":
            return .wine
        case "COCKTAIL":
            return .cocktail
        case "HIGHBALL":
            return .highball
        default:
            return .liquor
        }
    }
}
