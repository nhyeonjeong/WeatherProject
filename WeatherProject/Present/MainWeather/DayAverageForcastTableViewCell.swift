//
//  DayAverageForcastTableViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import UIKit

final class DayAverageForcastTableViewCell: BaseTableViewCell {

    private let weekLabel = UILabel().configureTextStyle(fontSize: 16)
    private let weatherImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let tempLabel = UILabel().configureTextStyle(align: .right, fontSize: 14, fontWeight: .light)
    
    override func configureHierarchy() {
        contentView.addSubViews([weekLabel, weatherImageView, tempLabel])
    }
    override func configureConstraints() {
        weekLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Constants.Constraint.safeAreaInset)
        }
        weatherImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(100)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        tempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .clear
    }
}

extension DayAverageForcastTableViewCell {
    func configureCell(_ data: DayForcastItem) {
        weekLabel.text = data.week
        weatherImageView.image = UIImage(named: data.descriptionImageString)
        tempLabel.text = data.averageTempMinMax
        self.backgroundColor = .clear
    }
}
