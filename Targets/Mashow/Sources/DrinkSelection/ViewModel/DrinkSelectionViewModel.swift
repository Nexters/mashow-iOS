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

    // About drinks
    func submitDrinks(_ drinks: [DrinkType: [String]]) {
        state.selectionResult.drinks = drinks
    }
    
    func clearDrinks() {
        state.selectionResult.drinks = [:]
    }
    
    // About rating
    func submitRating(_ rating: Int) {
        state.selectionResult.rating = rating
    }
    
    func clearRating() {
        state.selectionResult.rating = nil
    }
    
    // About foods
    func submitFoods(_ foods: [DrinkSelectionResult.Food]) {
        state.selectionResult.foods = foods
    }
    
    func clearFoods() {
        state.selectionResult.foods = []
    }
    
    // About memos
    func submitMemo(_ memo: DrinkSelectionResult.Memo) {
        state.selectionResult.memo = memo
    }
    
    func clearMemo() {
        state.selectionResult.memo = nil
    }
    
    // Clear all
    func flush() {
        state.selectionResult = .init()
    }
    
    // Save to server
    func saveRecord() {
        state.drinkSelectionResult.send(state.selectionResult)
    }
}

struct DrinkSelectionResult {
    var drinks: [DrinkType: [String]] = [:]
    var rating: Int?
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
