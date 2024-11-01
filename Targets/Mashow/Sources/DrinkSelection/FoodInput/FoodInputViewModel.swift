//
//  FoodInputViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/11/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

class FoodInputViewModel {
    struct Action {
        var onSubmitResult: ([String]) -> Void
    }
    
    private var action: Action
    
    init(action: Action) {
        self.action = action
    }
    
    func submitResult(chosenFoods: [String]) {
        action.onSubmitResult(chosenFoods)
    }
}
