//
//  DrinkDetailViewModel.swift
//  MashowTests
//
//  Created by ZENA on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

final class DrinkDetailViewModel {
    var drinkDetails: [DrinkType: [String]]
    
    init(drinkDetails: [DrinkType : [String]] = [:]) {
        self.drinkDetails = drinkDetails
    }
}
