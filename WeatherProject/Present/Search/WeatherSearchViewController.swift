//
//  WeatherSearchViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit

final class WeatherSearchViewController: BaseViewController {

    let mainView = WeatherSearchView()
    override func loadView() {
        view = mainView
    }
}
