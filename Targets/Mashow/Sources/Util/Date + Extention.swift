//
//  Date + Extention.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

extension Date {
    static func todayStringWrittenInKorean() -> String {
        // In M월 DD일 E요일
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 dd일 EEEE"
        return dateFormatter.string(from: Date())
    }
}
