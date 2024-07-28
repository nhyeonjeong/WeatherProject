//
//  WeatherSearchViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import RxCocoa
import RxSwift
import Toast
import UIKit

final class WeatherSearchViewController: BaseViewController {
    
    let clickedCityData: ((CityModel) -> Void)?
    
    private let viewModel: WeatherSearchViewModel
    
    private let mainView = WeatherSearchView()
    private let inputTextfieldTrigger: PublishRelay<Void> = PublishRelay()
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: WeatherSearchViewModel, clickedCityData: @escaping (CityModel) -> Void) {
        self.viewModel = viewModel
        self.clickedCityData = clickedCityData
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
        bind()
        // initial textfield 이벤트 전달
        inputTextfieldTrigger.accept(())
    }
    
    deinit {
        print("WeatherSearchViewCon Deinit")
    }
    
    private func bind() {
        let input = WeatherSearchViewModel.Input(inputTextfieldTrigger: inputTextfieldTrigger, inputTextField: mainView.searchBar.textfield.rx.text)
        let output = viewModel.transform(input: input)
        
        output.outputTableViewItems
            .drive(mainView.cityTableView.rx.items(cellIdentifier: CityTableViewCell.identifier, cellType: CityTableViewCell.self)) {(row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
        
        output.outputErrorToastMessage
            .drive(with: self) { owner, message in
                DispatchQueue.main.async {
                    owner.view.makeToast(message, duration: 1.0, position: .center)
                }
            }.disposed(by: disposeBag)
        
        output.outputIsResultEmpty
            .drive(with: self) { owner, value in
                owner.mainView.showNoResultMessage(value)
            }.disposed(by: disposeBag)
        
        // cell 선택
        mainView.cityTableView.rx.modelSelected(CityModel.self)
            .bind(with: self) { owner, cityData in
                owner.clickedCityData?(cityData)
                owner.dismiss(animated: true)
                
                // Userdefault 선택된 도시 저장
                UserDefaultManager.shared.saveSelectedCityModel(city: cityData)
            }.disposed(by: disposeBag)
    }
}
