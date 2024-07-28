//
//  DateFormatManager.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

final class DateFormatManager {
    static func utcToTimeString(utcString: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: utcString)
        guard let date else { return nil }
        
        formatter.dateFormat = "a h시"
        return formatter.string(from: date)
    }
    /// utcString에서 요일(한글) 반환
    static func getWeekData(utcString: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: utcString)
        guard let date else { return nil }
        
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
