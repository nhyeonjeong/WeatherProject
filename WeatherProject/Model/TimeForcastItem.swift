//
//  TimeForcastItem.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

struct TimeForcastItem {
    let utcTime: String
    let descriptionImageString: String
    let temp: String
    var timeString: String {
        return DateFormatManager.utcToTimeString(utcString: utcTime) ?? "-"
    }
}
