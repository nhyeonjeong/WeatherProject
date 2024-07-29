//
//  UserDefaultManager.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/29.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case selectedCity
}

final class UserDefaultManager {
    static let shared = UserDefaultManager()
    private let userDefault = UserDefaults.standard
    private init() { }
    
    func saveSelectedCityModel(city: CityModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(city) {
            userDefault.setValue(encoded, forKey: UserDefaultKey.selectedCity.rawValue)
        }
    }
    func getSelectedCityModel() -> CityModel? {
        guard let data = userDefault.data(forKey: UserDefaultKey.selectedCity.rawValue) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(CityModel.self, from: data)
    }
}
