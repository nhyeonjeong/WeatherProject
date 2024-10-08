//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

// API통신을 위한 구조체
struct CityWeatherModel: Decodable {
    enum WeatherIcon: String {
        case sunny = "01d"
        case clouds_02 = "02d"
        case clouds_03 = "03d"
        case clouds_all = "04d"
        case rain = "09d"
        case rainSunny = "10d"
        case thunder = "11d"
        case snow = "13d"
        case fog = "50d"
    }
    
    let cnt: Int
    let list: [List]
    let city: City
    
    // 공통으로 쓰일 새로운 구조체
    var newWeatherList: CityWeatherDTO {
        let weatherList = list.map { list in
            return WeatherList(temp: list.main.temp, temp_min: list.main.temp_min, temp_max: list.main.temp_max, humidity: list.main.humidity, clouds: list.clouds.all, windSpeed: list.wind.speed, dt_txt: list.dt_txt, main: list.weather[0].main, description: list.weather[0].description, icon: list.weather[0].icon)
        }
        return CityWeatherDTO(city: city, weatherList: weatherList)
    }

    var averageList: [HumidityCloudWindDTO] {
        let averageHumanity = Double(list.reduce(0) { $0 + ($1.main.humidity ?? 0)}) / Double(list.count)
        let averageCloud = Double(list.reduce(0) { $0 + $1.clouds.all}) / Double(list.count)
        let averageWindSpeed = list.reduce(0.0) { $0 + $1.wind.speed} / Double(list.count)
        return [HumidityCloudWindDTO(type: .humanity, number: averageHumanity),
                HumidityCloudWindDTO(type: .cloud, number: averageCloud),
                HumidityCloudWindDTO(type: .windSpeed, number: averageWindSpeed)]
    }
    
    var timeForcastItems: [TimeForcastDTO] {
        let data: [TimeForcastDTO] = list.map { list in
            let icon = list.weather[0].icon
            return TimeForcastDTO(utcTime:list.dt_txt, descriptionImageString: icon.replacingOccurrences(of: "n", with: "d"), temp: "\(Int(list.main.temp))°")
        }
        return data
    }
    
    var fiveDayForcastItems: [DayForcastDTO] {
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
    let main: String
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
    private func getFiveDaysWeathers() -> [DayForcastDTO] {
        guard var weekString = DateFormatManager.shared.getWeekData(utcString: list[0].dt_txt) else {
            return []
        }
        var data: [DayForcastDTO] = []
        var tempMin: Double = 100
        var tempMax: Double = -100
        var dayWeatherList: [WeatherIcon] = []
        for (index, weather) in list.enumerated() {
            if index != 0 && index % 8 == 0 {
                let weatheIcon = choiceWeatherIcon(dayWeatherList)
                data.append(DayForcastDTO(week: weekString, descriptionImageString: weatheIcon.rawValue, averageTempMin: tempMin, averageTempMax: tempMax))
                guard let week = DateFormatManager.shared.getWeekData(utcString: list[index].dt_txt) else {
                    return data
                }
                weekString = week
                // 초기화
                tempMin = 100
                tempMax = -100
                dayWeatherList = []
            }
            tempMin = min(tempMin, weather.main.temp_min)
            tempMax = max(tempMax, weather.main.temp_max)
            dayWeatherList.append(WeatherIcon(rawValue: weather.weather[0].icon.replacingOccurrences(of: "n", with: "d")) ?? .sunny)
        }
        let weatheIcon = choiceWeatherIcon(dayWeatherList)
        data.append(DayForcastDTO(week: weekString, descriptionImageString: weatheIcon.rawValue, averageTempMin: tempMin, averageTempMax: tempMax))
        data[0].week = "오늘"
        return data
    }
    
    private func choiceWeatherIcon(_ list: [WeatherIcon]) -> WeatherIcon {
        // 우선순위 : 눈 > 번개 > 비 > 실 비 > 나머지중 많이 나온 날씨
        if list.contains(.snow) {
            return .snow
        } else if list.contains(.thunder) {
            return .thunder
        } else if list.contains(.rain) {
            return .rain
        } else if list.contains(.rainSunny) {
            return .rainSunny
        } else {
            return findFrequentElemet(list) ?? .sunny
        }
    }
    
    private func findFrequentElemet<T: Hashable>(_ array: [T]) -> T? {
         var frequencyDict: [T: Int] = [:]
         for element in array {
             frequencyDict[element, default: 0] += 1
         }
         let mostFrequent = frequencyDict.max { a, b in a.value < b.value }
         return mostFrequent?.key
    }
}
