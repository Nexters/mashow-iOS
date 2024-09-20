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
    
    private(set) var state: State
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
        var currentPage: Int = 1 // Current page being loaded
        var totalPage: Int = 1 // Total pages from the API
        var isFetchingNextPage: Bool = false // Flag to prevent multiple simultaneous page loads
        
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
    
    // Pagination-aware function to update records
    func updateRecords(with drinkType: DrinkType, page: Int = 1, append: Bool = false) async throws {
        state.isLoading.send(true)
        
        let recordList = try await networkManager.request(
            .history(.getRecord(filters: [drinkType], userId: state.userId, page: page, size: 5)), // Size's fixed to max value(5)
            of: RecordListResponse.self).value
        
        let recordStat = try await networkManager.request(
            .history(.getStatistics(filters: [drinkType])),
            of: RecordStatResponse.self).value
        
        let baseRecordSet = recordList.contents.flatMap {
            $0.histories.map { $0.toRecordCellInformation() }
        }
        
        // Update the current and total page information
        state.currentPage = recordList.currentPageIndex
        state.totalPage = recordList.totalPageNumber
        
        // If append is true, add the new data to the existing records
        if append {
            let existingRecords = state.records.value
            state.records.send(existingRecords + baseRecordSet)
        } else {
            state.records.send(baseRecordSet)
        }
        
        self.state.recordStat.send(recordStat)
        self.state.isLoading.send(false)
    }
    
    // Function to fetch the next page of data
    func fetchNextPage() async throws {
        guard !state.isFetchingNextPage, state.currentPage < state.totalPage else {
            return
        }
        
        state.isFetchingNextPage = true
        let nextPage = state.currentPage + 1
        try await updateRecords(with: state.currentDrinkType.value, page: nextPage, append: true)
        state.isFetchingNextPage = false
    }
}

extension RecordListResponse.Value.Content.History {
    func toRecordCellInformation() -> RecordListViewController.RecordCellInformation {
        if liquorDetailNames.isEmpty {
            RecordListViewController.RecordCellInformation(
                id: UUID(),
                date: SharedDateFormatter.serverDateFormatter.date(from:drankAt),
                names: [],
                recordType: .record
            )
        } else {
            RecordListViewController.RecordCellInformation(
                id: UUID(),
                date: SharedDateFormatter.serverDateFormatter.date(from:drankAt),
                names: liquorDetailNames,
                recordType: .record
            )
        }
    }
}
