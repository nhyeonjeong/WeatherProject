//
//  MainWeatherViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit

final class MainWeatherViewController: BaseViewController {

    private let mainView = MainWeatherView()
    override func loadView() {
        view = mainView
    }
}
