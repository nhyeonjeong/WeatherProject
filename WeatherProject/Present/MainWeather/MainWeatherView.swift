//
//  MainWeatherView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import MapKit
import SnapKit
import UIKit

final class MainWeatherView: BaseView {
    enum SectionBox: CaseIterable {
        case timeForcast
        case dayForcast
        case map
        
        var boxTitle: String? {
            switch self {
            case .timeForcast: return "3시간 단위로 알려드립니다"
            case .dayForcast: return "5일간의 일기예보"
            case .map: return "강수량"
            }
        }
        var boxTitleHeight: CGFloat? {
            switch self {
            case .timeForcast, .dayForcast, .map: return 36
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
            case .timeForcast: return 90
            case .dayForcast: return 250
            case .map: return 240
            }
        }
    }

    private let backgroundImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    // searchBar
    let searchBar = CustomSearchBar(backColor: .white.withAlphaComponent(0.8))
    // 최상단 최근 날씨
    let mainWeatherView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    private let cityNameLabel = UILabel().configureTextStyle(align: .center, fontSize: 28)
    private let currentTempLabel = UILabel().configureTextStyle(align: .center, fontSize: 70)
    private let currentDescriptionLabel = UILabel().configureTextStyle(align: .center, fontSize: 20)
    private let tempMinMaxLabel = UILabel().configureTextStyle(align: .center, fontSize: 16, fontWeight: .light)
    
    // 3시간 간격으로 2일간 기온
    private lazy var timeForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 12, fontWeight: .semibold)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .timeForcast, contentView: timeForcastCollectionView)
        return view
    }()
    lazy var timeForcastCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.timeForcastCollectionViewLayout())
        view.register(TimeForcastCollectionViewCell.self, forCellWithReuseIdentifier: TimeForcastCollectionViewCell.identifier)
        view.allowsSelection = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    // 5일간 일기예보
    private lazy var dayForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 12, fontWeight: .semibold)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .dayForcast, contentView: dayForcastTableView)
        return view
    }()
    var dayForcastTableView: UITableView = {
        let view = UITableView()
        view.register(DayAverageForcastTableViewCell.self, forCellReuseIdentifier: DayAverageForcastTableViewCell.identifier)
        view.rowHeight = SectionBox.dayForcast.contentHeight / 5
        view.separatorColor = Constants.Color.text.withAlphaComponent(0.5)
        view.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.isScrollEnabled = false
        return view
    }()
    
    // 강수량 Map
    private lazy var mapForecastView: MainPointBoxView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 12, fontWeight: .semibold)
        let view = MainPointBoxView(headerTextLabel: headerLabel, boxType: .map, contentView: mapView)
        return view
    }()
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let mapViewMessageLabel = UILabel().configureTextStyle(align: .center, fontSize: 12)
    
    // 습도, 구름, 바람속도 표시 collectionView
    lazy var bottomWeatherCollectionView = {
        let headerLabel = UILabel().configureTextStyle(fontSize: 14)
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        view.backgroundColor = .clear
        view.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        view.isScrollEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.subviews.forEach { $0.isSkeletonable = true }
        contentView.subviews.forEach { $0.isSkeletonable = true }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        mainWeatherView.addSubViews([cityNameLabel, currentTempLabel, currentDescriptionLabel, tempMinMaxLabel])
        mapForecastView.addSubViews([mapViewMessageLabel])
        contentView.addSubViews([mainWeatherView, timeForecastView, dayForecastView, mapForecastView, bottomWeatherCollectionView])
        scrollView.addSubview(contentView)
        addSubViews([backgroundImageView, searchBar, scrollView])
    }
    override func configureConstratinst() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            make.height.equalTo(200)
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
        }
        
        timeForecastView.snp.makeConstraints { make in
            make.top.equalTo(mainWeatherView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        dayForecastView.snp.makeConstraints { make in
            make.top.equalTo(timeForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        mapForecastView.snp.makeConstraints { make in
            make.top.equalTo(dayForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
        mapViewMessageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        bottomWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mapForecastView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(330)
            make.bottom.equalToSuperview().inset(Constants.Constraint.safeAreaInset)
        }
    }
    override func configureView() {
        self.backgroundColor = .white
    }
}

extension MainWeatherView {
    func configureCurrentWeather(_ data: CityWeatherDTO?) {
        // 배경
        let currentWeather = data?.weatherList.first
        if let currentWeather {
            let weather = currentWeather.main.lowercased()
            backgroundImageView.image = weather == "clear" ? UIImage(named: "sunny") : UIImage(named: "\(currentWeather.main.lowercased())")
        }
        cityNameLabel.text = data?.city.name ?? "-"
        currentTempLabel.text = "\(currentWeather?.temp ?? 0)°"
        currentDescriptionLabel.text = currentWeather?.description ?? "-"
        tempMinMaxLabel.text = "최고: \(currentWeather?.temp_max ?? 0)°  |  최저: \(currentWeather?.temp_min ?? 0)°"
        
        viewUpToTop() // 스크롤뷰 제일 위로 올리기
        hideToast() // 토스트 숨기기
        configureUserInteractionEnabled(value: true)
    }
    
    func addAnnotationWithMoveCamera(_ city: City?, message: String? = nil) {
        guard let city else {
            mapView.isHidden = true
            mapViewMessageLabel.text = message
            return
        }
        mapView.isHidden = false
        
        let lat = city.coord.lat
        let lon = city.coord.lon
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(annotation)
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2) // 줌 레벨 설정
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    func viewUpToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    func showSkeletonView() {
        contentView.showAnimatedGradientSkeleton()
        configureUserInteractionEnabled(value: false)
    }
    func removeSkeletonView() {
        configureUserInteractionEnabled(value: true)
        guard NWPathMonitorManager.shared.isConnected == false else {
            self.makeToast("네트워크 연결이 끊겼습니다", duration: 2.0, position: .top)
            return
        }
        contentView.hideSkeleton()
    }
    func configureUserInteractionEnabled(value: Bool) {
        searchBar.isUserInteractionEnabled = value
    }
}

extension MainWeatherView {
    private func timeForcastCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: SectionBox.timeForcast.contentHeight) // 없으면 안됨
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
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
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        }
        group.interItemSpacing = .fixed(10) // item간의 가로 간격
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.Constraint.safeAreaInset
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.Constraint.safeAreaInset, bottom: 0, trailing: Constants.Constraint.safeAreaInset)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
