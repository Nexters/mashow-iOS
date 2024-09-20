//
//  RecordDetailViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 9/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class RecordDetailViewModel {
    let state: State
    
    struct State {
        let drinkType: DrinkType // FIXME: 나중엔 히스토리 아이디 받아서 직접 fetch 해야 함
        let liquorNames: [String] // FIXME: 나중엔 히스토리 아이디 받아서 직접 fetch 해야 함
        
        let drinkInfo = CurrentValueSubject<DrinkInfo?, Never>(nil)
        
        init(drinkType: DrinkType, liquorNames: [String]) {
            self.drinkType = drinkType
            self.liquorNames = liquorNames
        }
    }
    
    init(state: State) {
        self.state = state
    }
    
    func fetchDrinkInfo() async throws {
        state.drinkInfo.send(
            DrinkInfo(
                drinkType: state.drinkType,
                memo: "",
                rating: 3,
                sideDishes: [])
        )
    }
}

extension RecordDetailViewModel {
    struct DrinkInfo {
        let drinkType: DrinkType
        let memo: String?
        let rating: Int?
        let sideDishes: [String]
    }
}
