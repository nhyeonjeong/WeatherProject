//
//  MainPointBoxView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import SnapKit
import UIKit

class MainPointBoxView: BaseView {

    let headerTextLabel: UILabel?
    let headerHeight: CGFloat?
    init(headerTextLabel: UILabel?, headerHeight: CGFloat?) {
        self.headerTextLabel = headerTextLabel
        self.headerHeight = headerHeight
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerLabel = UILabel().configureTextStyle(fontSize: 12)
    private let headerUnderLine = UIView()
    
    override func configureHierarchy() {
        guard let headerTextLabel else {
            return
        }
        addSubViews([headerTextLabel, headerUnderLine])
    }
    override func configureConstratinst() {
        guard let headerTextLabel else {
            return
        }
        headerTextLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight ?? 30)
        }
        headerUnderLine.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
    }
    override func configureView() {
        self.layer.cornerRadius = 10
        self.backgroundColor = Constants.Color.point
    }
}
