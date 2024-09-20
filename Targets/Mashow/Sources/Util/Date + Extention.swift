//
//  Date + Extention.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

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

extension Date {
    static func todayStringWrittenInKorean() -> String {
        // In M월 DD일 E요일
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 dd일 EEEE"
        return dateFormatter.string(from: Date())
    }
}
