//
//  WeatherSearchViewModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Foundation
import RxCocoa
import RxSwift

final class WeatherSearchViewModel: InputOutput {
    struct CityModel: Decodable {
        let id: Int
        let name: String
        let country: String
        let coord: Coord
    }
    
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Input {
        let inputTextfieldTrigger: PublishRelay<Void>
        let inputTextField: ControlProperty<String?>
    }
    struct Output {
        let outputTableViewItems: Driver<[CityModel]>
        let outputErrorToastMessage: Driver<String>
        let outputIsResultEmpty: Driver<Bool>
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let outputTableViewItems = PublishRelay<[CityModel]>()
        let outputErrorToastMessage = PublishRelay<String>()
        let outputIsResultEmpty = PublishRelay<Bool>()
        
        let searchCityTrigger = PublishSubject<String>()
        
        // initial textfield event
        input.inputTextfieldTrigger
            .bind(with: self) { owner, _ in
                searchCityTrigger.onNext("")
            }.disposed(by: disposeBag)
        
        // 이후 textfield Event
        input.inputTextField.orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                searchCityTrigger.onNext(text)
        }.disposed(by: disposeBag)
        
        // cityList search
        searchCityTrigger
            .bind(with: self) { owner, text in
                guard let items = owner.searchJsonData() else {
                    // json -> CityModel로 변환하는 과정 중 실패 후 nil로 넘어왔을 시
                    outputErrorToastMessage.accept("에러가 발생했습니다")
                    return
                }
                let filteredItems = text == "" ? items : items.filter {$0.name.localizedCaseInsensitiveContains(text)}
                outputTableViewItems.accept(filteredItems)
                
                if filteredItems.isEmpty {
                    // 검색결과 없음
                    outputIsResultEmpty.accept(true)
                } else {
                    outputIsResultEmpty.accept(false)
                }
            }.disposed(by: disposeBag)
        
        return Output(outputTableViewItems: outputTableViewItems.asDriver(onErrorJustReturn: []),
                      outputErrorToastMessage: outputErrorToastMessage.asDriver(onErrorJustReturn: "에러가 발생했습니다"),
                      outputIsResultEmpty: outputIsResultEmpty.asDriver(onErrorJustReturn: false))
    }
}

extension WeatherSearchViewModel {
    
    private func searchJsonData() -> [CityModel]? {
        
        let fileName = "reduced_citylist"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return nil }

        do {
            let jsonData = try Data(contentsOf: fileLocation)
            let encodingResult = try JSONDecoder().decode([CityModel].self, from: jsonData)
            return encodingResult
        } catch {
            print("🐈‍⬛", error)
            return nil
        }
    }
}
