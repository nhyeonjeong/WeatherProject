//
//  BaseView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstratinst()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    func configureConstratinst() {
        
    }
    func configureView() {
        
    }
}
