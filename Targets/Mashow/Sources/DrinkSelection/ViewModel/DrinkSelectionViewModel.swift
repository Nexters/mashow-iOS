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
        let currentType = CurrentValueSubject<DrinkType, Never>(DrinkType.soju)
        let addedTypes = CurrentValueSubject<[DrinkType], Never>([])
        let drinkSelectionResult = PassthroughSubject<DrinkSelectionResult, Never>()
        
        var selectionResult = DrinkSelectionResult()
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

    func submitDrinks(_ drinks: [DrinkSelectionResult.DrinkDetail]) {
        state.selectionResult.drinks = drinks
    }
    
    func submitFoods(_ foods: [DrinkSelectionResult.Food]) {
        state.selectionResult.foods = foods
    }
    
    func submitMemo(_ memo: DrinkSelectionResult.Memo) {
        state.selectionResult.memo = memo
    }
}

struct DrinkSelectionResult {
    var drinks: [DrinkDetail] = []
    var foods: [Food]?
    var memo: Memo?
}

extension DrinkSelectionResult {
    struct DrinkDetail {
        let drinkType: DrinkType
        let description: String
    }
    
    struct Food {
        let description: String
    }
    
    struct Memo {
        let description: String
    }
}
