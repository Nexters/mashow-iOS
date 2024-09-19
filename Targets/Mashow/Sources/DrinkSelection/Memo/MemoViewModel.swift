//
//  MemoViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/26/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class MemoViewModel {
    struct State {
        let memo: CurrentValueSubject<String?, Never> = .init(nil)
    }
    
    let state: State
    
    
    init() {
        self.state = State()
    }
}
