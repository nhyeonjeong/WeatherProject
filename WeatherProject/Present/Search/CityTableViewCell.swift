//
//  CityTableViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit
import SnapKit

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
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.normal
        return view
    }()
    
    override func configureHierarchy() {
        addSubViews([nameLabel, countryLabel, bottomLine])
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
        }
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
            make.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        backgroundColor = .clear
    }
}

extension CityTableViewCell {
    func configureCell(_ data: WeatherSearchViewModel.CityModel) {
        nameLabel.text = data.name
        countryLabel.text = data.country
    }
}

