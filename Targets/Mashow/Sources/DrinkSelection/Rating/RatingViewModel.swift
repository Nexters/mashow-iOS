//
//  RatingViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/25/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class RatingViewModel {
    struct State {
        let score: CurrentValueSubject<Int?, Never> = .init(nil)
    }
    
    let state: State
    
    // This view model doesn't need injection
    init() {
        self.state = State()
    }
}

extension RatingViewModel {
    func updateScore(_ score: Int) {
        state.score.send(score)
    }
}
