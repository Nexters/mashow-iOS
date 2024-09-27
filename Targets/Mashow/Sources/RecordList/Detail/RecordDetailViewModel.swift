//
//  RecordDetailViewModel.swift
//  Mashow
//
//  Created by Kai Lee on 9/20/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Combine

class RecordDetailViewModel {
    private let networkManager: NetworkManager<API>
    let state: State
    
    struct State {
        let historyId: Int
        let dateString: String
        let drinkInfo = CurrentValueSubject<DrinkRecordInfo?, Never>(nil)
        let error: PassthroughSubject<Error?, Never> = .init()
    }
    
    init(state: State, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.networkManager = networkManager
    }
    
    func fetchDrinkInfo() async throws {
        let recordDetail = try await networkManager.request(
            .history(.getLiquorHistoryDetail(historyId: state.historyId)),
            of: RecordDetailResponse.self).value
        
        guard let drinkInfo = recordDetail.toDrinkRecordInfo() else {
            throw InternalError.noData
        }
        
        state.drinkInfo.send(drinkInfo)
    }
    
    func deleteDrinkInfo() async throws {
//        _ = try await networkManager.request(
//            .history(.deleteLiquorHistory(historyId: state.historyId)))
    }
}

extension RecordDetailViewModel {
    struct DrinkRecordInfo {
        let drinkType: DrinkType
        let drinkName: String
        let memo: String?
        let rating: Int?
        let sideDishes: [String]
    }
    
    enum InternalError: Error {
        case noData
    }
}

extension RecordDetail {
    func toDrinkRecordInfo() -> RecordDetailViewModel.DrinkRecordInfo? {
        guard  let liqour = self.liquors.first else {
            return nil
        }

        let drinkType = DrinkType.fromAPIResoponse(liqour.liquorType)
        let drinkName = liqour.details.first?.names ?? ""
        let sideDishes = self.sideDishes.map({ $0.names })
        let memo = self.memos.first?.description

        return RecordDetailViewModel.DrinkRecordInfo(
            drinkType: drinkType,
            drinkName: drinkName,
            memo: memo,
            rating: rating,
            sideDishes: sideDishes
        )
    }
}
