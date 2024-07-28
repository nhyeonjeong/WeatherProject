//
//  BottomCollectionViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import SnapKit
import UIKit

final class BottomCollectionViewCell: BaseCollectionViewCell {
    enum Section: Int, CaseIterable {
        case humanity = 0
        case cloud
        case windSpeed
        
        var sectionTitle: String {
            switch self {
            case .humanity: return "습도"
            case .cloud: return "구름"
            case .windSpeed: return "바람 속도"
            }
        }
        var sectionUnit: String {
            switch self {
            case .humanity: return "%"
            case .cloud: return "%"
            case .windSpeed: return "m/s"
            }
        }
    }
    
    private let titleLabel = UILabel().configureTextStyle(fontSize: 14)
    private let contentLabel = {
        let view = UILabel().configureTextStyle(fontSize: 26, fontWeight: .semibold)
        view.numberOfLines = 2
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubViews([titleLabel, contentLabel])
    }
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
            make.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .black.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 10
    }
}

extension BottomCollectionViewCell {
    func configureCell(_ data: MainBottomCollectionViewSectionData) {
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
}
