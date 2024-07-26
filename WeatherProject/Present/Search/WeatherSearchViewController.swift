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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

extension WeatherSearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        mainView.cityTableView.dataSource = self
        mainView.cityTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell()
        return cell
    }
}
