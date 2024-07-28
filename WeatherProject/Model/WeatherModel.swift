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
    
    let averageHumanity: Double
    let averageCloud: Double
    let averageWindSpeed: Double
    
    let averageList: [MainBottomCollectionViewSectionData]
    
    enum CodingKeys: CodingKey {
        case cnt
        case list
        case city
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cnt = try container.decode(Int.self, forKey: .cnt)
        self.list = try container.decode([List].self, forKey: .list)
        self.city = try container.decode(City.self, forKey: .city)
        
        self.averageHumanity = Double(list.reduce(0) { $0 + ($1.main.humanity ?? 0)}) / Double(list.count)
        self.averageCloud = Double(list.reduce(0) { $0 + $1.clouds.all}) / Double(list.count)
        self.averageWindSpeed = list.reduce(0.0) { $0 + $1.wind.speed} / Double(list.count)
        self.averageList = [MainBottomCollectionViewSectionData(title: .humanity, number: averageHumanity),
                            MainBottomCollectionViewSectionData(title: .cloud, number: averageCloud),
                            MainBottomCollectionViewSectionData(title: .windSpeed, number: averageWindSpeed)]
    }

    var timeForcastItems: [TimeForcastItem] {
        let data: [TimeForcastItem] = list.map { list in
            var icon = list.weather[0].icon

            return TimeForcastItem(utcTime:list.dt_txt, descriptionImageString: icon.replacingOccurrences(of: "n", with: "d"), temp: "\(Int(list.main.temp))°")
        }
        return data
    }
}

struct List: Decodable {
    let main: Main
    let weather: [Weather]
    let clouds: Cloud
    let wind: Wind
    let dt_txt: String
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humanity: Int?
}

struct Weather: Decodable {
    let description: String
    let icon: String
}
struct Cloud: Decodable {
    let all: Int
}
struct Wind: Decodable {
    let speed: Double
}

struct City: Decodable {
    let name: String
    let coord: Coord
    let country: String
}
