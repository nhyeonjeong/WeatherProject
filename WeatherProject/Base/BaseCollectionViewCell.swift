//
//  BaseCollectionViewCell.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/28.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    func configureConstraints() {
        
    }
    func configureView() {
        
    }
}
