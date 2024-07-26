//
//  UIView+Extension.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
