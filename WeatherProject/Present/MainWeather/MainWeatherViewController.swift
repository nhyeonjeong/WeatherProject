//
//  MainWeatherViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import RxCocoa
import RxSwift
import SkeletonView
import UIKit
import Toast

final class MainWeatherViewController: BaseViewController {
    
    private let viewModel: MainWeatherViewModel
    
    private let mainView = MainWeatherView()
    private let disposeBag = DisposeBag()
    private let searchBarTapGesture = UITapGestureRecognizer()
    private let inputFetchCityWeatherTrigger: PublishSubject<CityModel> = PublishSubject()
    private let inputFetchTimeForcastTrigger: PublishSubject<CityModel> = PublishSubject()
    
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.showSkeletonView()
        bind()
        // initial data
        let selectedCity: CityModel? = UserDefaultManager.shared.getSelectedCityModel()
        inputFetchCityWeatherTrigger.onNext(selectedCity ?? CityModel.seoulCity)
        inputFetchTimeForcastTrigger.onNext(selectedCity ?? CityModel.seoulCity)
        
        // 네트워크 재연결시 대응
        setNetworkTask {
            let selectedCity: CityModel? = UserDefaultManager.shared.getSelectedCityModel()
            self.inputFetchCityWeatherTrigger.onNext(selectedCity ?? CityModel.seoulCity)
            self.inputFetchTimeForcastTrigger.onNext(selectedCity ?? CityModel.seoulCity)
        }
    }
    private func bind() {
        searchBarTapGesture.rx.event
            .bind(with: self) { owner, text in
                owner.present(WeatherSearchViewController(viewModel: WeatherSearchViewModel(), clickedCityData: { cityData in
                    owner.inputFetchCityWeatherTrigger.onNext(cityData)
                    owner.inputFetchTimeForcastTrigger.onNext(cityData)
                    let loadingToastView = LoadingToastView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                    owner.mainView.showToast(loadingToastView, duration: .infinity, position: .center)
                    owner.mainView.configureUserInteractionEnabled(value: false)
                }), animated: true)
            }.disposed(by: disposeBag)
        
        let input = MainWeatherViewModel.Input(inputFetchCityWeatherTrigger: inputFetchCityWeatherTrigger,
                                               inputFetchTimeForcastTrigger: inputFetchTimeForcastTrigger)
        let output = viewModel.transform(input: input)
        // 상단 날씨 UI 업데이트
        output.outputCityWeather
            .drive(with: self) { owner, weather in
                owner.mainView.configureCurrentWeather(weather)
                owner.mainView.removeSkeletonView()
            }.disposed(by: disposeBag)
        
        // 3시간마다의 날씨
        output.outputTimeForcastCollectionViewItems
            .map { $0 ?? [] }
            .drive(mainView.timeForcastCollectionView.rx.items(cellIdentifier: TimeForcastCollectionViewCell.identifier, cellType: TimeForcastCollectionViewCell.self)) {(row, element, cell) in
                cell.configureCell(element, row: row)
            }.disposed(by: disposeBag)
        
        // 5일 일기예보
        output.outputDayForcastTableViewItems
            .map { $0 ?? [] }
            .drive(mainView.dayForcastTableView.rx.items(cellIdentifier: DayAverageForcastTableViewCell.identifier, cellType: DayAverageForcastTableViewCell.self)) {(row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
        
        // map
        output.outputMapLocation
            .drive(with: self) { owner, city in
                owner.mainView.addAnnotationWithMoveCamera(city)
            }.disposed(by: disposeBag)
        
        // 하단 습도, 구름, 바람속도 UI 업데이트
        output.outputBottomCollectionViewItems
            .map { $0 ?? [] }
            .drive(mainView.bottomWeatherCollectionView.rx.items(cellIdentifier: BottomCollectionViewCell.identifier, cellType: BottomCollectionViewCell.self)) {(row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
    }
    override func configureView() {
        // searchBar에 대한 tapgesture
        mainView.searchBar.addGestureRecognizer(searchBarTapGesture)
        mainView.searchBar.textfield.isEnabled = false
    }
}
