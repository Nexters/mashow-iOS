//
//  SubTargetType.swift
//  Mashow
//
//  Created by Kai Lee on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Moya
import Foundation

/// `TargetType`의 `case`가 과도하게 늘어나는 걸 방지하기 위해
/// path 별로 sub case를 나누기 위해 만든 프로토콜입니다.
/// `baseURL`, `headers`를 제외한 것들을 구현해 전달합니다.
protocol SubTargetType: TargetType {}

extension SubTargetType {
    /// 사용하는 `TargetType`의 것을 사용해야 함
    var baseURL: URL { fatalError("Shouldn't be used") }
    /// 사용하는 `TargetType`의 것을 사용해야 함
    var headers: [String : String]? { fatalError("Shouldn't be used") }
}
