//
//  MainWeatherViewModel.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Foundation
import RxCocoa
import RxSwift

final class MainWeatherViewModel: InputOutput {
    
    struct Input {
        let inputFetchCityWeatherTrigger: PublishSubject<CityModel>
    }
    struct Output {
        let outputCityWeather: Driver<CityWeatherModel?>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let outputCityWeather: PublishRelay<CityWeatherModel?> = PublishRelay()
        input.inputFetchCityWeatherTrigger
            .flatMap { cityData in
                return NetworkManager.shared.fetchAPI(type: CityWeatherModel.self, router: WeatherAPIRequest.currentWeather(lat: cityData.coord.lat, lon: cityData.coord.lon))
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .bind(with: self) { owner, weather in
                outputCityWeather.accept(weather)
            }.disposed(by: disposeBag)
        
        return Output(outputCityWeather: outputCityWeather.asDriver(onErrorJustReturn: nil))
    }
}
