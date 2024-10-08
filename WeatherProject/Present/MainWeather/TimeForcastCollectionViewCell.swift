//
//  TimeForcastCollectionViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import SnapKit
import UIKit

final class TimeForcastCollectionViewCell: BaseCollectionViewCell {
    
    private let timeLabel = UILabel().configureTextStyle(align: .center, fontSize: 12)
    private let weatherImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let tempLabel = UILabel().configureTextStyle(align: .center, fontSize: 14, fontWeight: .bold)
    
    override func configureHierarchy() {
        contentView.addSubViews([timeLabel, weatherImageView, tempLabel])
    }
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.centerX.equalTo(contentView)
            make.size.equalTo(30)
        }
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(2)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(6)
            make.height.equalTo(20)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .clear
    }
}

extension TimeForcastCollectionViewCell {
    func configureCell(_ weather: TimeForcastDTO, row: Int) {
        timeLabel.text = row == 0 ? "지금" : weather.timeString
        weatherImageView.image = UIImage(named: weather.descriptionImageString)
        tempLabel.text = "\(weather.temp)"
    }
}
