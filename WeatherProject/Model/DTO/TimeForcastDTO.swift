//
//  TimeForcastItem.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

struct TimeForcastDTO {
    let utcTime: String
    let descriptionImageString: String
    let temp: String
    var timeString: String {
        return DateFormatManager.shared.utcToTimeString(utcString: utcTime) ?? "-"
    }
}
