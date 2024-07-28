//
//  WeatherSearchView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class WeatherSearchView: BaseView {

    let searchBar = CustomSearchBar(backColor: .white.withAlphaComponent(0.8))
    
    let cityTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        view.keyboardDismissMode = .onDrag
        view.separatorColor = .white.withAlphaComponent(0.5)
        view.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return view
    }()
    
    private let noResultMessageLabel = {
        let view = UILabel()
        view.text = "검색 결과가 없습니다"
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .center
        view.textColor = Constants.Color.text
        return view
    }()
    
    override func configureHierarchy() {
        addSubViews([searchBar, cityTableView, noResultMessageLabel])
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
        noResultMessageLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = .black.withAlphaComponent(0.8)
        
    }
}

extension WeatherSearchView {
    func showNoResultMessage(_ value: Bool) {
        noResultMessageLabel.isHidden = !value
    }
}

