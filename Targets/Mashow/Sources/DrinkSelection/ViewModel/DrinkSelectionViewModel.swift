//
//  DrinkSelectionViewModel.swift
//  Mashow
//
//  Created by ZENA on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import Combine

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
                ["FFC1AD", "BCE7FF"]
            }
        }
    }
    
    struct State {
        var currentType = CurrentValueSubject<DrinkType, Never>(DrinkType.soju)
        var addedTypesPublisher = CurrentValueSubject<[DrinkType], Never>([])
    }
    
    var state: State
    
    init(state: State) {
        self.state = state
    }
    
    func addType(_ type: DrinkType) {
        guard state.addedTypesPublisher.value.count < 3, !state.addedTypesPublisher.value.contains(type) else { return }
        var current = state.addedTypesPublisher.value
        current.append(type)
        state.addedTypesPublisher.send(current)
    }
    
    func removeType(_ type: DrinkType) {
        guard state.addedTypesPublisher.value.contains(type) else { return }
        var current = state.addedTypesPublisher.value
        guard let targetIndex = current.firstIndex(of: type) else { return }
        current.remove(at: targetIndex)
        state.addedTypesPublisher.send(current)
    }
}
