//
//  DayForcastItem.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

struct DayForcastItem {
    var week: String
    let descriptionImageString: String
    let averageTempMin: Double
    let averageTempMax: Double

    var averageTempMinMax: String {
        "최저: \(averageTempMin)°  최고: \(averageTempMax)°"
    }
}
