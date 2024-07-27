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
    
    private let viewModel: WeatherSearchViewModel
    
    private let mainView = WeatherSearchView()
    private let inputTextfieldTrigger: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: WeatherSearchViewModel) {
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
        bind()
        // textfield 이벤트 전달
        inputTextfieldTrigger.accept("")
    }
    
    deinit {
        print("WeatherSearchViewCon Deinit")
    }
    
    private func bind() {
        
        let input = WeatherSearchViewModel.Input(inputTextfieldTrigger: inputTextfieldTrigger)
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
    }
}
