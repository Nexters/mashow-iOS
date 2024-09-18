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
    typealias RecordCellInformation = RecordListViewController.RecordCellInformation
    
    struct State {
        let nickname: String
        let fetchableDrinkTypes: [DrinkType]
        let currentDrinkType: CurrentValueSubject<DrinkType, Never>
        
        let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
        let records: CurrentValueSubject<[RecordCellInformation], Never> = .init([])
        let recordStat: CurrentValueSubject<RecordStat?, Never> = .init(nil)
        
        init(nickname: String, fetchableDrinkTypes: [DrinkType], drinkTypeToBeShown drinkType: DrinkType) {
            self.nickname = nickname
            self.fetchableDrinkTypes = fetchableDrinkTypes
            self.currentDrinkType = .init(drinkType)
        }
    }
    
    let state: State
    private let networkManager: NetworkManager<API>
    
    // MARK: - Convenience
    var currentDrinkType: DrinkType {
        state.currentDrinkType.value
    }
    
    init(state: State, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.networkManager = networkManager
    }
    
    func updateCurrentDrinkType(with drinkType: DrinkType) {
        state.currentDrinkType.send(drinkType)
    }
    
    func updateRecords(with drinkType: DrinkType) async throws {
        // FIXME: Connect API later
        let testDateSet = [
            "2024.07.22", "2024.07.24", "2024.07.31", "2024.06.10", "2024.06.30", "2024.05.30", "2023.06.30", "2023.06.10"
        ]
        
        state.isLoading.send(true)
        
        let recordStat = try await networkManager.request(
            .history(.getStatistics(filters: [drinkType.forAPIParameter])),
            of: RecordStatResponse.self).value
        
        var baseRecordSet = [RecordCellInformation]()
        
        switch drinkType {
        case .soju:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "처음처럼", recordType: .record)
            }
        case .liquor:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "짐빔", recordType: .record)
            }
        case .makgeolli:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "느린마을", recordType: .record)
            }
        case .sake:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "가토", recordType: .record)
            }
        case .beer:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "버드와이저", recordType: .record)
            }
        case .wine:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "메를로", recordType: .record)
            }
        case .cocktail:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "블러드메리", recordType: .record)
            }
        case .highball:
            baseRecordSet += testDateSet.map {
                RecordCellInformation(id: UUID(), date: $0, name: "얼그레이하이볼", recordType: .record)
            }
        }
        
        self.state.recordStat.send(recordStat)
        self.state.records.send(baseRecordSet)
        self.state.isLoading.send(false)
    }
}
