//
//  WeatherSearchView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit
import SnapKit

final class WeatherSearchView: BaseView {

    private let searchBar: CustomSearchBar = {
        let view = CustomSearchBar()
        view.layer.cornerRadius = 8
        view.searchBarBox.backgroundColor = Constants.Color.normal
        return view
    }()
    
    private let cityTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func configureHierarchy() {
        addSubViews([searchBar, cityTableView])
    }
    override func configureConstratinst() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(Constants.Constraint.safeAreaInset)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.Constraint.safeAreaInset)
        }
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constants.Constraint.safeAreaInset)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.Constraint.safeAreaInset)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = Constants.Color.point
    }
}
