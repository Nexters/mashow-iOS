//
//  HomeViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 8/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine
import UIKit

class HomeViewModel {
    private let networkManager: NetworkManager<API>
    
    struct State {
        let nickname: String
        let userId: Int
        let gptResult: PassthroughSubject<Result<SpiritGPT.Spirit, Error>, Never> = .init()
        let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
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
    
    func askGPT(with image: UIImage) async throws -> SpiritGPT.Spirit? {
        state.isLoading.send(true)
        
        guard
            let recognizedText = try await OCRManager.extractText(from: image)
        else {
            state.isLoading.send(false)
            return nil
        }
        
        do {
            let result = try await SpiritGPT.ask(recognizedText)
            state.gptResult.send(.success(result))
            state.isLoading.send(false)
            
            return result
        } catch let error as SpiritGPT.GPTError {
            state.gptResult.send(.failure(error))
            state.isLoading.send(false)
            throw error
        } catch {
            throw SpiritGPT.GPTError.network
        }
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
