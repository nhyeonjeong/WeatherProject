//
//  NewWeatherModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/29.
//

import Foundation

struct CityWeatherDTO {
    let city: City
    let weatherList: [WeatherList]
}
struct WeatherList {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int?
    
    let clouds: Int
    let windSpeed: Double
    let dt_txt: String
    
    let main: String
    let description: String
    let icon: String
}
