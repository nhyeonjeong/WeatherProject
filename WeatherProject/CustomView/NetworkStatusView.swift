//
//  NetworkStatusView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/29.
//

import Network
import SnapKit
import UIKit

final class NetworkStatusView: BaseView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 연결 끊김"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let statusLabel = UILabel().configureTextStyle(align: .center, fontSize: 8)
    
    override func configureHierarchy() {
        backgroundView.addSubViews([statusLabel])
        addSubViews([backgroundView])
    }
    override func configureConstratinst() {
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
        }
    }
    override func configureView() {

    }
}
