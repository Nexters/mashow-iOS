//
//  RecordListVIewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/30/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class RecordListViewModel {
    typealias Record = RecordListViewController.Record
    
    struct State {
        let nickname: String
        let currentDrinkType: CurrentValueSubject<DrinkType, Never>
        
        let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
        let records: CurrentValueSubject<[Record], Never> = .init([])
        
        init(nickname: String, drinkTypeToBeShown drinkType: DrinkType) {
            self.nickname = nickname
            self.currentDrinkType = .init(drinkType)
        }
    }
    
    let state: State
    
    // MARK: - Convenience
    var currentDrinkType: DrinkType {
        state.currentDrinkType.value
    }
    
    init(state: State) {
        self.state = state
    }
    
    func updateCurrentDrinkType(with drinkType: DrinkType) {
        state.currentDrinkType.send(drinkType)
    }
    
    func updateRecords(with drinkType: DrinkType) {
        // FIXME: Connect API later
        let testDateSet = [
            "2024.07.22", "2024.07.24", "2024.07.31", "2024.06.10", "2024.06.30", "2024.05.30", "2023.06.30", "2023.06.10"
        ]
        
        state.isLoading.send(true)
        
        // Assume API call takes 1 second
        // 만약 로딩 중에 또 요청이 들어온다면 그 태스크를 취소하는 로직을 추가해야 함
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            var baseRecordSet = [Record(id: UUID(), date: nil, type: nil, recordType: .overview)]

            switch drinkType {
            case .soju:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "처음처럼", recordType: .record)
                }
            case .liquor:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "짐빔", recordType: .record)
                }
            case .makgeolli:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "느린마을", recordType: .record)
                }
            case .sake:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "가토", recordType: .record)
                }
            case .beer:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "버드와이저", recordType: .record)
                }
            case .wine:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "메를로", recordType: .record)
                }
            case .cocktail:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "블러드메리", recordType: .record)
                }
            case .highball:
                baseRecordSet += testDateSet.map {
                    Record(id: UUID(), date: $0, type: "얼그레이하이볼", recordType: .record)
                }
            }
            
            self.state.records.send(baseRecordSet)
            self.state.isLoading.send(false)
        }
    }
}
