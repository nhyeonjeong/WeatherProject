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

    private let mainView = MainWeatherView()
    private let disposeBag = DisposeBag()
    private let searchBarTapGesture = UITapGestureRecognizer()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // searchBar에 대한 tapgesture
        mainView.searchBar.addGestureRecognizer(searchBarTapGesture)
        bind()
    }
    private func bind() {
        searchBarTapGesture.rx.event
            .bind(with: self) { owner, text in
                owner.present(WeatherSearchViewController(viewModel: WeatherSearchViewModel()), animated: true)
            }.disposed(by: disposeBag)
    }
    override func configureView() {
        mainView.searchBar.textfield.isEnabled = false
    }
}
