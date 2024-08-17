//
//  DrinkSelectionViewModel.swift
//  Mashow
//
//  Created by ZENA on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class DrinkSelectionViewModel {
    enum DrinkType: String, CaseIterable {
        case soju, liquor, makgeolli, sake, beer, wine, cocktail, highball, mixed
        
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
            case .mixed:
                ["FFFFFF", "FFFFFF"] // FIXME: - 여기 컬러 뭐임
            }
        }
    }
    
    struct State {
        var isTypeAdded: [DrinkType: Bool] {
            var isAdded = [DrinkType: Bool]()
            DrinkType.allCases.forEach { type in
                isAdded[type] = false
            }
            return isAdded
        }
    }
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
}
