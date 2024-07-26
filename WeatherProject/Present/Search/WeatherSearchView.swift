//
//  WeatherSearchView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import UIKit
import SnapKit

final class WeatherSearchView: BaseView {

    let searchBar: CustomSearchBar = {
        let view = CustomSearchBar()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let cityTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func configureHierarchy() {
        addSubViews([searchBar, cityTableView])
    }
    override func configureConstratinst() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = .lightGray
    }
}
