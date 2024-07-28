//
//  CityTableViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class CityTableViewCell: BaseTableViewCell {
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.textColor = Constants.Color.text
        return view
    }()
    private let countryLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = Constants.Color.text
        return view
    }()
    
    override func configureHierarchy() {
        addSubViews([nameLabel, countryLabel])
    }
    override func configureConstraints() {
        // content
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(18)
            make.height.equalTo(20)
        }
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    override func configureView() {
        backgroundColor = .clear
    }
}

extension CityTableViewCell {
    func configureCell(_ data: CityModel) {
        nameLabel.text = data.name
        countryLabel.text = data.country
    }
}

