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
        let inputTextfieldTrigger: BehaviorRelay<String>
    }
    struct Output {
        let outputTableViewItems: Driver<[CityModel]>
        let outputErrorToastMessage: Driver<String>
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let outputTableViewItems = PublishRelay<[CityModel]>()
        let outputErrorToastMessage = PublishRelay<String>()
        
        input.inputTextfieldTrigger.bind(with: self) { owner, text in
            guard let items = owner.searchJsonData() else {
                // json -> CityModel로 변환하는 과정 중 실패 후 nil로 넘어왔을 시
                // .추가
                outputErrorToastMessage.accept("에러가 발생했습니다")
                return
            }
            outputTableViewItems.accept(items)
        }.disposed(by: disposeBag)
        
        return Output(outputTableViewItems: outputTableViewItems.asDriver(onErrorJustReturn: []),
                      outputErrorToastMessage: outputErrorToastMessage.asDriver(onErrorJustReturn: "에러가 발생했습니다"))
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
