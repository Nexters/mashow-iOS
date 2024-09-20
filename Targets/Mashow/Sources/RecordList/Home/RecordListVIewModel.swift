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
    
    let state: State
    let action: Action
    private let networkManager: NetworkManager<API>
    
    struct State {
        let nickname: String
        let userId: Int
        let fetchableDrinkTypes: [DrinkType]
        let currentDrinkType: CurrentValueSubject<DrinkType, Never>
        
        let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
        let records: CurrentValueSubject<[RecordCellInformation], Never> = .init([])
        let recordStat: CurrentValueSubject<RecordStat?, Never> = .init(nil)
        
        init(nickname: String, userId: Int, fetchableDrinkTypes: [DrinkType], drinkTypeToBeShown drinkType: DrinkType) {
            self.nickname = nickname
            self.userId = userId
            self.fetchableDrinkTypes = fetchableDrinkTypes
            self.currentDrinkType = .init(drinkType)
        }
    }
    
    struct Action {
        let refreshHomeWhenSubmitted: @Sendable () async throws -> Void
    }
    
    init(state: State, action: Action, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.action = action
        self.networkManager = networkManager
    }
    
    // MARK: - Convenience
    var currentDrinkType: DrinkType {
        state.currentDrinkType.value
    }
    
    func updateCurrentDrinkType(with drinkType: DrinkType) {
        state.currentDrinkType.send(drinkType)
    }
    
    func updateRecords(with drinkType: DrinkType) async throws {
        state.isLoading.send(true)
        
        let recordList = try await networkManager.request(
            .history(.getRecord(filters: [drinkType], userId: state.userId, page: 1, size: 5)),
            of: RecordListResponse.self).value
        
        let recordStat = try await networkManager.request(
            .history(.getStatistics(filters: [drinkType])),
            of: RecordStatResponse.self).value
        
        let baseRecordSet = recordList.contents.flatMap {
            $0.histories.flatMap { $0.toRecordCellInformation() }
        }
        
        self.state.recordStat.send(recordStat)
        self.state.records.send(baseRecordSet)
        self.state.isLoading.send(false)
    }
}

struct SharedDateFormatter {
    static let serverDateFormatter: DateFormatter = {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent formatting
        serverDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC time zone
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // Format for microseconds
        
        return serverDateFormatter
    }()
    
    static let shortDateFormmater: DateFormatter = {
        let shortDateFormmater = DateFormatter()
        shortDateFormmater.dateFormat = "yyyy.MM.dd"
        
        return shortDateFormmater
    }()
}

extension RecordListResponse.Value.Content.History {
    func toRecordCellInformation() -> [RecordListViewController.RecordCellInformation] {
        if liquorDetailNames.isEmpty {
            [
                RecordListViewController.RecordCellInformation(
                    id: UUID(),
                    date: SharedDateFormatter.serverDateFormatter.date(from:drankAt),
                    name: "",
                    recordType: .record
                )
            ]
        } else {
            liquorDetailNames.map { history in
                RecordListViewController.RecordCellInformation(
                    id: UUID(),
                    date: SharedDateFormatter.serverDateFormatter.date(from:drankAt),
                    name: history,
                    recordType: .record
                )
            }
        }
    }
}
