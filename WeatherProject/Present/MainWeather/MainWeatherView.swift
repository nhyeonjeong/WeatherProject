//
//  MainWeatherView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class MainWeatherView: BaseView {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    // searchBar
    let searchBar = CustomSearchBar(backColor: Constants.Color.light)
    // 최상단 최근 날씨
    private let mainWeatherView = UIView()
    private let cityNameLabel = UILabel().configureTextStyle(align: .center, fontSize: 28)
    private let currentTempLabel = UILabel().configureTextStyle(align: .center, fontSize: 70)
    private let currentDescriptionLabel = UILabel().configureTextStyle(align: .center, fontSize: 20)
    private let tempMinMaxLabel = UILabel().configureTextStyle(align: .center, fontSize: 16, fontWeight: .light)
    
    override func configureHierarchy() {
        mainWeatherView.addSubViews([cityNameLabel, currentTempLabel, currentDescriptionLabel, tempMinMaxLabel])
        contentView.addSubViews([mainWeatherView])
        scrollView.addSubview(contentView)
        addSubViews([searchBar, scrollView])
    }
    override func configureConstratinst() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.Constraint.safeAreaInset)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constants.Constraint.safeAreaInset)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        mainWeatherView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        currentTempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        currentDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTempLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        tempMinMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(currentDescriptionLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        self.backgroundColor = Constants.Color.normal
    }
}

extension MainWeatherView {
    func configureCurrentWeather(_ data: CityWeatherModel?) {
        cityNameLabel.text = data?.city.name ?? "-"
        currentTempLabel.text = "\(data?.list[0].main.temp ?? 0)°"
        currentDescriptionLabel.text = data?.list[0].weather[0].description ?? "-"
        tempMinMaxLabel.text = "최고: \(data?.list[0].main.temp_max ?? 0)°  |  최저: \(data?.list[0].main.temp_min ?? 0)°"
    }
}
