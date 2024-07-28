//
//  WeatherAPIRequest.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Alamofire
import Foundation

enum WeatherAPIRequest {
    
    case currentWeather(lat: Double, lon: Double, cnt: Int?)
    
}

extension WeatherAPIRequest: RouterType {
    
    var baseURLString: String {
        return "\(APIKey.baseURL.rawValue)\(APIKey.urlVersion.rawValue)/forecast"
    }
    var commonQuery: [URLQueryItem] {
        [URLQueryItem(name: QueryKey.units.rawValue, value: "metric"),
         URLQueryItem(name: QueryKey.lang.rawValue, value: "kr"),
         URLQueryItem(name: QueryKey.appid.rawValue, value: "\(APIKey.apiKey.rawValue)")]
    }
    var method: Alamofire.HTTPMethod {
        switch self {
        case .currentWeather:
            return .get
        }
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .currentWeather(let lat, let lon, let cnt):
            return commonQuery + [URLQueryItem(name: QueryKey.lat.rawValue, value: "\(lat)"),
                                  URLQueryItem(name: QueryKey.lon.rawValue, value: "\(lon)"),
                                  URLQueryItem(name: QueryKey.cnt.rawValue, value: "\(cnt ?? 7)")]
        }
    }
}
