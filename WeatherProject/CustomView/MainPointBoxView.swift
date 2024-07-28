//
//  MainPointBoxView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import SnapKit
import UIKit

class MainPointBoxView: BaseView {

    private let headerTextLabel: UILabel?
    private let boxType: MainWeatherView.SectionBox
    private let contentView: UIView
    private let headerUnderLine = UIView()
    
    init(headerTextLabel: UILabel?, boxType: MainWeatherView.SectionBox, contentView: UIView) {
        self.headerTextLabel = headerTextLabel
        self.boxType = boxType
        self.contentView = contentView
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        guard let headerTextLabel else {
            addSubViews([contentView])
            return
        }
        if boxType.isUnderLined {
            addSubViews([headerTextLabel, headerUnderLine, contentView])
        } else {
            addSubViews([headerTextLabel, contentView])
        }
    }
    override func configureConstratinst() {
        guard let headerTextLabel else {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return
        }
        headerTextLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
            make.top.equalToSuperview()
            make.height.equalTo(boxType.boxTitleHeight ?? 30)
        }
        if boxType.isUnderLined {
            headerUnderLine.snp.makeConstraints { make in
                make.top.equalTo(headerTextLabel.snp.bottom)
                make.height.equalTo(1)
                make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
            }
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom)
            make.height.equalTo(boxType.contentHeight)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.headerUnderLine.backgroundColor = Constants.Color.text.withAlphaComponent(0.5)
        self.headerTextLabel?.text = boxType.boxTitle
    }
}
