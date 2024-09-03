//
//  FoodInputHomeViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/11/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class FoodInputHomeViewModel {
    struct State {
        var foodItems: PassthroughSubject<[String], Never> = .init()
    }
    
    var state: State = State()
}
