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
    case getRecord(filters: [DrinkType], userId: Int, page: Int, size: Int) /// But method is `post`. Why?
    case getStatistics(filters: [DrinkType])
    case getLiquorHistoryDetail(historyId: Int)
    case getLiquorTypes
}

extension HistoryAPI: SubTargetType {
    var path: String {
        switch self {
        case .postLiquorHistory:
            return "/history/liquor"
        case .getRecord:
            return "/history/monthly"
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
        case .postLiquorHistory, .getRecord:
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
        case let .getRecord(filters, userId, page, size):
            // JSON body에 데이터를 보내기 위한 예시
            return .requestParameters(
                parameters: [
                    "filters": filters.map(\.forAPIParameter),
                    "userId": userId,
                    "paginationRequest": ["page": page, "size": size]
                ],
                encoding: JSONEncoding.default
            )
        case let .getStatistics(filters):
            return .requestParameters(
                parameters: ["filters": filters.map(\.forAPIParameter)],
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
        case .getRecord:
            return Data("""
            {
              "code": 0,
              "message": "string",
              "value": {
                "totalPageNumber": 1,
                "currentPageIndex": 1,
                "pageSize": 1,
                "isLastPage": true,
                "totalElementNumber": 1,
                "contents": [
                  {
                    "year": 2021,
                    "month": 8,
                    "histories": [
                      {
                        "drankAt": "2024-09-20T01:03:01.428Z",
                        "liquorDetailNames": [
                          "string"
                        ]
                      }
                    ]
                  }
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
