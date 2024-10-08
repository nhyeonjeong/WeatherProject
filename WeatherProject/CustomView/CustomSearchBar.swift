//
//  CustomSearchBar.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class CustomSearchBar: BaseView {
    
    init(backColor: UIColor?) {
        super.init(frame: .zero)
        self.searchBarBox.backgroundColor = backColor ?? .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchBarBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let magnifyingglassIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")
        view.tintColor = Constants.Color.searchBarTint
        return view
    }()
    
    let textfield: UITextField = {
        let view = UITextField()
        view.placeholder = "    Search"
        return view
    }()
    
    override func configureHierarchy() {
        searchBarBox.addSubViews([magnifyingglassIcon, textfield])
        addSubview(searchBarBox)
    }
    override func configureConstratinst() {
        searchBarBox.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        magnifyingglassIcon.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(8)
            make.size.equalTo(18)
        }
        textfield.snp.makeConstraints { make in
            make.leading.equalTo(magnifyingglassIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
}
