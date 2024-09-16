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
    private let networkManager: NetworkManager<API>
    
    struct State {
        let currentType = CurrentValueSubject<DrinkType, Never>(DrinkType.soju)
        let addedTypes = CurrentValueSubject<[DrinkType], Never>([])
        let drinkSelectionResult = PassthroughSubject<DrinkDetail, Never>()
        
        var selectionResult = DrinkDetail()
    }
    
    var state: State
    
    init(state: State, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.networkManager = networkManager
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
    func saveLiquors(_ liquors: [DrinkDetail.Liquor]) {
        state.selectionResult.liquors = liquors
    }
    
    func clearLiquors() {
        state.selectionResult.liquors = []
    }
    
    // About rating
    func saveRating(_ rating: Int) {
        state.selectionResult.rating = rating
    }
    
    func clearRating() {
        state.selectionResult.rating = nil
    }
    
    // About foods
    func saveSideDishes(_ sideDishes: [DrinkDetail.SideDish]) {
        state.selectionResult.sideDishes = sideDishes
    }
    
    func clearSideDishes() {
        state.selectionResult.sideDishes = []
    }
    
    // About memos
    func saveMemo(_ memo: DrinkDetail.Memo) {
        state.selectionResult.memo = memo
    }
    
    func clearMemo() {
        state.selectionResult.memo = nil
    }
    
    /// Clear all
    func flush() {
        state.selectionResult = .init()
    }
    
    /// Submit saved record to server
    func submit() async throws {
        _ = try await networkManager.request(
            .history(.postLiquorHistory(drinkDetail: state.selectionResult)))
        
        state.drinkSelectionResult.send(state.selectionResult)
    }
}
