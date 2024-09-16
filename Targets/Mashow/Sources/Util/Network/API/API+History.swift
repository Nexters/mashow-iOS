//
//  API+History.swift
//  KakaoSDKAuth
//
//  Created by Kai Lee on 9/16/24.
//

import Moya
import Foundation

enum HistoryAPI {
    case postLiquorHistory(drinkDetail: DrinkDetail)
    case getStatistics(filters: [String])
    case getLiquorHistoryDetail(historyId: Int)
    case getLiquorTypes
}

extension HistoryAPI: SubTargetType {
    var path: String {
        switch self {
        case .postLiquorHistory:
            return "/history/liquor"
        case .getStatistics:
            return "/history/statistic"
        case let .getLiquorHistoryDetail(historyId):
            return "/history/liquor/\(historyId)"
        case .getLiquorTypes:
            return "/history/liquor-types"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLiquorHistory:
            return .post
        case .getStatistics, .getLiquorHistoryDetail, .getLiquorTypes:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .postLiquorHistory(drinkDetail):
            do {
                let jsonData = try JSONEncoder().encode(drinkDetail)
                return .requestData(jsonData)
            } catch {
                return .requestPlain // Fallback in case of encoding failure
            }
        case let .getStatistics(filters):
            return .requestParameters(
                parameters: ["filters": filters],
                encoding: URLEncoding.queryString
            )
        case .getLiquorHistoryDetail, .getLiquorTypes:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .postLiquorHistory:
            return Data("""
            {
              "code": 0,
              "message": "Success",
              "value": {
                "liquorHistoryId": 123,
                "liquors": [
                  {
                    "liquorType": "SOJU",
                    "details": [
                      { "names": "참이슬" }
                    ]
                  }
                ],
                "drankAt": "2024-09-16T01:44:35.868Z",
                "rating": 3,
                "memos": [
                  { "description": "즐거웠습니다." }
                ],
                "sideDishes": [
                  { "names": "오뎅탕 / 치킨..." }
                ]
              }
            }
            """.utf8)
        case .getStatistics:
            return Data("""
            {
              "code": 0,
              "message": "Success",
              "value": {
                "names": "소주",
                "frequencyPercentage": 100
              }
            }
            """.utf8)
        case .getLiquorHistoryDetail:
            return Data("""
            {
              "code": 0,
              "message": "Success",
              "value": {
                "liquorHistoryId": 123,
                "liquors": [
                  {
                    "liquorType": "SOJU",
                    "details": [
                      { "names": "참이슬" }
                    ]
                  }
                ],
                "drankAt": "2024-09-16T01:44:35.873Z",
                "rating": 3,
                "memos": [
                  { "description": "즐거웠습니다." }
                ],
                "sideDishes": [
                  { "names": "오뎅탕 / 치킨..." }
                ]
              }
            }
            """.utf8)
        case .getLiquorTypes:
            return Data("""
            {
              "code": 0,
              "message": "Success",
              "value": {
                "liquorHistoryTypes": ["SOJU"]
              }
            }
            """.utf8)
        }
    }
}
