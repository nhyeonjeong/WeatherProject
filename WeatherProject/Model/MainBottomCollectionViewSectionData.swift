//
//  MainBottomCollectionViewSectionData.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import Foundation

/// Main화면 하단 습도, 구름, 바람 속도 데이터
struct MainBottomCollectionViewSectionData {
    let type: BottomCollectionViewCell.Section
    let number: Double
    var title: String {
        type.sectionTitle
    }
    var content: String {
        "\(String(format: "%.2f", number))\(type.sectionUnit)"
    }
}
