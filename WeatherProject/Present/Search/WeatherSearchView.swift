//
//  WeatherSearchView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class WeatherSearchView: BaseView {

    let searchBar = CustomSearchBar(backColor: Constants.Color.normal)
    
    let cityTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
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
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = Constants.Color.point
    }
}
