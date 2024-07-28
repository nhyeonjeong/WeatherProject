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
    }

    var averageList: [MainBottomCollectionViewSectionData] {
        let averageHumanity = Double(list.reduce(0) { $0 + ($1.main.humidity ?? 0)}) / Double(list.count)
        let averageCloud = Double(list.reduce(0) { $0 + $1.clouds.all}) / Double(list.count)
        let averageWindSpeed = list.reduce(0.0) { $0 + $1.wind.speed} / Double(list.count)
        return [MainBottomCollectionViewSectionData(type: .humanity, number: averageHumanity),
                MainBottomCollectionViewSectionData(type: .cloud, number: averageCloud),
                MainBottomCollectionViewSectionData(type: .windSpeed, number: averageWindSpeed)]
    }
    
    var timeForcastItems: [TimeForcastItem] {
        let data: [TimeForcastItem] = list.map { list in
            let icon = list.weather[0].icon
            return TimeForcastItem(utcTime:list.dt_txt, descriptionImageString: icon.replacingOccurrences(of: "n", with: "d"), temp: "\(Int(list.main.temp))°")
        }
        return data
    }
    
    var fiveDayForcastItems: [DayForcastItem] {
        return getFiveDaysWeathers()
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
    let humidity: Int?
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


extension CityWeatherModel {
    func getFiveDaysWeathers() -> [DayForcastItem] {
        guard var weekString = DateFormatManager.getWeekData(utcString: list[0].dt_txt) else {
            return []
        }
        var data: [DayForcastItem] = []
        var tempMin: Double = 100
        var tempMax: Double = -100
        for (index, weather) in list.enumerated() {
            print("😎\(weekString)")
            if index != 0 && index % 8 == 0 {
                print("👀")
                data.append(DayForcastItem(week: weekString, descriptionImageString: "04d", averageTempMin: tempMin, averageTempMax: tempMax))
                guard let week = DateFormatManager.getWeekData(utcString: list[index].dt_txt) else {
                    return data
                }
                weekString = week
                // 초기화
                tempMin = 100
                tempMax = -100
            }
            tempMin = min(tempMin, weather.main.temp_min)
            tempMax = max(tempMax, weather.main.temp_max)
        }
        data.append(DayForcastItem(week: weekString, descriptionImageString: "04d", averageTempMin: tempMin, averageTempMax: tempMax))
        data[0].week = "오늘"
        return data
    }
}
