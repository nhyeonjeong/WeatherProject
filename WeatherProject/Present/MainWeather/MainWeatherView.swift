//
//  MainWeatherView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import SnapKit
import UIKit

final class MainWeatherView: BaseView {
    enum SectionBox: CaseIterable {
        case timeForcast
        case dayForcast
        case map
        
        var boxTitle: String? {
            switch self {
            case .timeForcast: return "3시간 마다의 일기예보"
            case .dayForcast: return "5일간의 일기예보"
            case .map: return "강수량"
            }
        }
        var boxTitleHeight: CGFloat? {
            switch self {
            case .timeForcast: return 40
            case .dayForcast: return 30
            case .map: return 30
            }
        }
        var isUnderLined: Bool {
            switch self {
            case .timeForcast, .dayForcast: return true
            case .map: return false
            }
        }
        var contentHeight: CGFloat {
            switch self {
            case .timeForcast: return 100
            case .dayForcast: return 250
            case .map: return 100
            }
        }
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    // searchBar
    let searchBar = CustomSearchBar(backColor: Constants.Color.light)
    // 최상단 최근 날씨
    private let mainWeatherView = UIView()
    private let cityNameLabel = UILabel().configureTextStyle(align: .center, fontSize: 28)
    private let currentTempLabel = UILabel().configureTextStyle(align: .center, fontSize: 70)
    private let currentDescriptionLabel = UILabel().configureTextStyle(align: .center, fontSize: 20)
    private let tempMinMaxLabel = UILabel().configureTextStyle(align: .center, fontSize: 16, fontWeight: .light)
    
    // 3시간 간격으로 2일간 기온 & 5일간 일기예보 & 강수량 Map
    lazy var timeForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 14, fontWeight: .semibold)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .timeForcast, contentView: timeForcastCollectionView)
        return view
    }()
    lazy var timeForcastCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.timeForcastCollectionViewLayout())
        view.register(TimeForcastCollectionViewCell.self, forCellWithReuseIdentifier: TimeForcastCollectionViewCell.identifier)
        view.allowsSelection = false
        view.backgroundColor = .clear
        return view
    }()
    
    // 5일간 일기예보
    lazy var dayForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 14)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .dayForcast, contentView: dayForcastTableView)
        return view
    }()
    var dayForcastTableView: UITableView = {
        let view = UITableView()
        view.register(DayAverageForcastTableViewCell.self, forCellReuseIdentifier: DayAverageForcastTableViewCell.identifier)
        view.rowHeight = SectionBox.dayForcast.contentHeight / 5
        view.separatorColor = Constants.Color.normal
        view.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.backgroundColor = .clear
        view.allowsSelection = false
        return view
    }()
    
    // 강수량 Map
    let mapForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 14)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .map, contentView: UIView())
        return view
    }()
    
    // 습도, 구름, 바람속도 표시 collectionView
    lazy var bottomWeatherCollectionView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 14)
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        view.backgroundColor = .clear
        view.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        return view
    }()
    
    override func configureHierarchy() {
        mainWeatherView.addSubViews([cityNameLabel, currentTempLabel, currentDescriptionLabel, tempMinMaxLabel])
        contentView.addSubViews([mainWeatherView, timeForecastView, dayForecastView, mapForecastView, bottomWeatherCollectionView])
        scrollView.addSubview(contentView)
        addSubViews([searchBar, scrollView])
    }
    override func configureConstratinst() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.Constraint.safeAreaInset)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constants.Constraint.safeAreaInset)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        mainWeatherView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        currentTempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        currentDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTempLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        tempMinMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(currentDescriptionLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        timeForecastView.snp.makeConstraints { make in
            make.top.equalTo(mainWeatherView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        dayForecastView.snp.makeConstraints { make in
            make.top.equalTo(timeForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
//            make.height.equalTo(200) // 임시
        }
        mapForecastView.snp.makeConstraints { make in
            make.top.equalTo(dayForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
//            make.height.equalTo(100) // 임시
        }
        bottomWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mapForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(400) // 임시
            make.bottom.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
    }
    override func configureView() {
        self.backgroundColor = Constants.Color.normal
    }
}

extension MainWeatherView {
    func configureCurrentWeather(_ data: CityWeatherModel?) {
        cityNameLabel.text = data?.city.name ?? "-"
        currentTempLabel.text = "\(data?.list[0].main.temp ?? 0)°"
        currentDescriptionLabel.text = data?.list[0].weather[0].description ?? "-"
        tempMinMaxLabel.text = "최고: \(data?.list[0].main.temp_max ?? 0)°  |  최저: \(data?.list[0].main.temp_min ?? 0)°"
    }
}

extension MainWeatherView {
    private func timeForcastCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: SectionBox.timeForcast.contentHeight) // 없으면 안됨
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) { // 16버전 이상에서
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            print("iOS 16.0이상")
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            print("iOS 15.0이하")
        }
        group.interItemSpacing = .fixed(10) // item간의 가로 간격
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.Constraint.safeAreaInset
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.Constraint.safeAreaInset, bottom: 0, trailing: Constants.Constraint.safeAreaInset)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
