//
//  HomeViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel {
    struct State {
        let nickname: String
        let records: CurrentValueSubject<Set<DrinkType>, Never> = .init([]) // FIXME: Fix me after the API implemented
    }
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
}
