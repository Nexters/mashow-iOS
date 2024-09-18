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
    private let networkManager: NetworkManager<API>
    
    struct State {
        let nickname: String
        let records: CurrentValueSubject<Set<DrinkType>?, Never> = .init(nil)
        let accessToken: CurrentValueSubject<String?, Never>
        
        let error: PassthroughSubject<Error?, Never> = .init()
    }
    
    let state: State
    
    init(state: State, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.networkManager = networkManager
        
        Task {
            do {
                try await refresh()
            } catch {
                state.error.send(error)
            }
        }
    }
    
    func refresh() async throws {
        let fetchedRecords = try await fetchRecordsFromServer()
        state.records.send(fetchedRecords)
    }
}

extension HomeViewModel {
    private func fetchRecordsFromServer() async throws -> Set<DrinkType> {
        let response = try await networkManager.request(.history(.getLiquorTypes),
                                                        of: LiquorTypesResponse.self)
        let types = response.value.liquorHistoryTypes.map { DrinkType.fromAPIResoponse($0) }
        return Set(types)
    }
}
