//
//  UILabel+Extension.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit

extension UILabel {
    /// align: .left, fontWeight: .regular
    func configureTextStyle(align: NSTextAlignment = .left, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular, textColor: UIColor = Constants.Color.text) -> UILabel {
        self.textColor = textColor
        self.textAlignment = align
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        return self
    }
}
