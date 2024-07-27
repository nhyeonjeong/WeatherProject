//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

// API통신을 위한 구조체
struct CityWeatherModel: Decodable {
    let cnt: Int
    let list: [List]
    let city: City
}

struct List: Decodable {
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let description: String
}

struct City: Decodable {
    let name: String
    let coord: Coord
    let country: String
}
