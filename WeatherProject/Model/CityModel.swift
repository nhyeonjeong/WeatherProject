//
//  CityModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

// cityList json파일 파싱을 위한 구조체
struct CityModel: Decodable {
    let id: Int
    let name: String
    let country: String
    let coord: Coord
    
    static var seoulCity: CityModel = CityModel(id: 1839726, name: "Asan", country: "KR", coord: Coord(lon: 127.004173, lat: 36.783611))
}
/// WeatherModel과 공통으로 사용
struct Coord: Decodable {
    let lon: Double
    let lat: Double
}
