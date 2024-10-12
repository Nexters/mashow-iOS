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
    let selectionLimit = 1
    private let networkManager: NetworkManager<API>
        
    struct State {
        let initialDrinkType: DrinkType?
        let currentType: CurrentValueSubject<DrinkType, Never>
        let addedTypes = CurrentValueSubject<[DrinkType], Never>([])
        let drinkSelectionResult = PassthroughSubject<DrinkDetail, Never>()
        let isLoading = CurrentValueSubject<Bool, Never>(false)
        let goToNextPageWithDrinkName = CurrentValueSubject<String?, Never>(nil)
        
        var selectionResult = DrinkDetail()
        
        init(initialDrinkType: DrinkType?) {
            if let initialDrinkType {
                self.initialDrinkType = initialDrinkType
                self.currentType = CurrentValueSubject(initialDrinkType)
                
                // 만약에 먼가가 여기로 들어왔다면 선택된 채로 보여주기
                self.addedTypes.send([initialDrinkType])
                self.selectionResult.liquors = [.init(liquorType: initialDrinkType.forAPIParameter, names: [])]
            } else {
                let defaultType = DrinkType.soju
                self.initialDrinkType = defaultType
                self.currentType = CurrentValueSubject(defaultType)
            }
        }
        
        init(initialDrinkType: DrinkType, drinkName: String) {
            self.initialDrinkType = initialDrinkType
            self.currentType = CurrentValueSubject(initialDrinkType)
            
            // 만약에 먼가가 여기로 들어왔다면 선택된 채로 보여주기
            self.addedTypes.send([initialDrinkType])
            self.selectionResult.liquors = [.init(liquorType: initialDrinkType.forAPIParameter, names: [])]
            
            // 그리고 simulated tap next
            self.goToNextPageWithDrinkName.send(drinkName)
        }
    }
    
    struct Action {
        let onSubmitted: @Sendable () async throws -> Void
    }
    
    var state: State
    var action: Action
    
    init(
        state: State,
        action: Action,
        networkManager: NetworkManager<API> = Environment.network
    ) {
        self.state = state
        self.action = action
        self.networkManager = networkManager
    }
    
    func addType(_ type: DrinkType) throws {
        var current = state.addedTypes.value
        guard state.addedTypes.value.count < selectionLimit, !current.contains(type) else {
            throw InternalError.limitExceeded
        }
        current.append(type)
        
        saveLiquors(current.map({ .init(liquorType: $0.forAPIParameter, names: []) }))
        state.addedTypes.send(current)
    }
    
    func removeType(_ type: DrinkType) {
        var current = state.addedTypes.value
        current.removeAll(where: { $0 == type })
        
        saveLiquors(current.map({ .init(liquorType: $0.forAPIParameter, names: []) }))
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
        state.isLoading.send(true)
        defer { state.isLoading.send(false) }
        
        _ = try await networkManager.request(
            .history(.postLiquorHistory(drinkDetail: state.selectionResult)))
        
        try await action.onSubmitted()
        state.drinkSelectionResult.send(state.selectionResult)
    }
}

extension DrinkSelectionViewModel {
    enum InternalError: Error {
        case limitExceeded
    }
}
