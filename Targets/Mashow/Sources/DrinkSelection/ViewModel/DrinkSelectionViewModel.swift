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
    
    struct State {
        var currentType = CurrentValueSubject<DrinkType, Never>(DrinkType.soju)
        var addedTypes = CurrentValueSubject<[DrinkType], Never>([])
    }
    
    var state: State
    
    init(state: State) {
        self.state = state
    }
    
    func addType(_ type: DrinkType) {
        var current = state.addedTypes.value
        guard state.addedTypes.value.count < 3, !current.contains(type) else { return }
        current.append(type)
        state.addedTypes.send(current)
    }
    
    func removeType(_ type: DrinkType) {
        var current = state.addedTypes.value
        guard current.contains(type) else { return }
        guard let targetIndex = current.firstIndex(of: type) else { return }
        current.remove(at: targetIndex)
        state.addedTypes.send(current)
    }
}
