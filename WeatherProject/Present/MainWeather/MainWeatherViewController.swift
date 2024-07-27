//
//  MainWeatherViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import RxCocoa
import RxSwift
import UIKit

final class MainWeatherViewController: BaseViewController {

    private let viewModel: MainWeatherViewModel
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView = MainWeatherView()
    private let disposeBag = DisposeBag()
    private let searchBarTapGesture = UITapGestureRecognizer()
    private let inputFetchCityWeatherTrigger: PublishSubject<CityModel> = PublishSubject()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        inputFetchCityWeatherTrigger.onNext(CityModel.seoulCity)
    }
    private func bind() {
        searchBarTapGesture.rx.event
            .bind(with: self) { owner, text in
                owner.present(WeatherSearchViewController(viewModel: WeatherSearchViewModel()), animated: true)
            }.disposed(by: disposeBag)
        
        let input = MainWeatherViewModel.Input(inputFetchCityWeatherTrigger: inputFetchCityWeatherTrigger)
        let output = viewModel.transform(input: input)
        output.outputCityWeather
            .drive(with: self) { owner, weather in
                owner.mainView.configureCurrentWeather(weather)
            }.disposed(by: disposeBag)
    }
    override func configureView() {
        // searchBar에 대한 tapgesture
        mainView.searchBar.addGestureRecognizer(searchBarTapGesture)
        mainView.searchBar.textfield.isEnabled = false
    }
}
